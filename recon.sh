#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a tool if the user agrees
install_tool() {
    tool_name=$1
    install_command=$2

    echo "$tool_name is not installed. Would you like to install it? (Y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        eval "$install_command"
        echo "$tool_name has been installed."
    else
        echo "$tool_name is required to run this script. Exiting..."
        exit 1
    fi
}

# List of required tools and their installation commands
declare -A tools=(
    ["subfinder"]="go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    ["httpx"]="go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
    ["katana"]="go install -v github.com/projectdiscovery/katana/cmd/katana@latest"
    ["waybackarchive"]="go install -v github.com/tomnomnom/waybackurls@latest"
    ["commoncrawl"]="go install -v github.com/lc/commoncrawl@latest"
    ["alienvault"]="go install -v github.com/x1mdev/ReconPi/functions/alienvault@latest"
)

# Check if each tool is installed, prompt to install if not
for tool in "${!tools[@]}"; do
    if ! command_exists "$tool"; then
        install_tool "$tool" "${tools[$tool]}"
    fi
done

# Proceed with the original script after ensuring all tools are installed
target=$1
mkdir "$target"
cd "$target" || exit
subfinder -d "$target" -all -recursive > subdomain.txt
httpx -l subdomain.txt -o live.txt 
katana -u live.txt -d 5 -ps -pss waybackarchive,commoncrawl,alienvault -kf -jc -fx -ef woff,css,png,svg,jpg,woff2,jpeg,gif,svg -o allurls.txt
cat allurls.txt | grep '=' > fuzz.txt
cat allurls.txt | grep -iE "\.js$" >> alljs.txt
nuclei -l "$PWD/alljs.txt" -t /root/priv8-Nuclei/js/
nuclei -l "$PWD/fuzz.txt" -t /root/priv8-Nuclei/ -dast
