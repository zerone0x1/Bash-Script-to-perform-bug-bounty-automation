# Automated Reconnaissance Tool Documentation

## Overview

This script is designed to automate the reconnaissance phase of security testing by discovering subdomains, probing live domains, gathering URLs, and performing vulnerability scans using various tools. The output includes files that can be further processed with custom Nuclei templates.

## Requirements

Before running the script, ensure the following tools are installed on your system:

- **subfinder**: For subdomain enumeration.
- **httpx**: To probe live domains.
- **katana**: For crawling and gathering URLs.
- **waybackarchive**: To retrieve URLs from the Wayback Machine.
- **commoncrawl**: To retrieve URLs from the Common Crawl.
- **alienvault**: To retrieve URLs from AlienVault.

If any of these tools are not installed, the script will prompt you to install them.

## Installation

### Tool Installation

The script checks if each required tool is installed. If a tool is missing, you will be prompted with the option to install it automatically.

For example, if `alienvault` is not installed, the script will ask:

```
alienvault is not installed. Would you like to install it? (Y/n)
```

If you press `Enter` (default), the tool will be installed. If you press `n`, the script will exit, as the tool is necessary for the script to run.

### Commands to Install Each Tool

Here are the commands used in the script to install the required tools:

- **subfinder**:  
  ```
  go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
  ```

- **httpx**:  
  ```
  go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
  ```

- **katana**:  
  ```
  go install -v github.com/projectdiscovery/katana/cmd/katana@latest
  ```

- **waybackarchive**:  
  ```
  go install -v github.com/tomnomnom/waybackurls@latest
  ```

- **commoncrawl**:  
  ```
  go install -v github.com/lc/commoncrawl@latest
  ```

- **alienvault**:  
  ```
  go install -v github.com/x1mdev/ReconPi/functions/alienvault@latest
  ```

## Script Usage

### Running the Script

To use the script, run the following command in your terminal:

```bash
./recon.sh <target-domain>
```

Replace `<target-domain>` with the domain you wish to scan.

### Output Files

The script generates several output files containing different types of information:

- **alljs.txt**: Contains URLs ending with `.js`, which are JavaScript files.
- **allurls.txt**: Contains all the gathered URLs.
- **fuzz.txt**: Contains URLs with parameters (`=`) for fuzzing potential vulnerabilities.
- **lfi.txt**: Reserved for potential Local File Inclusion (LFI) vulnerabilities (if added).
- **live.txt**: Contains live subdomains after probing with `httpx`.
- **redir.txt**: Reserved for potential open redirects (if added).
- **sqli.txt**: Reserved for potential SQL Injection (SQLi) vulnerabilities (if added).
- **subdomain.txt**: Contains all discovered subdomains.
- **xss.txt**: Reserved for potential Cross-Site Scripting (XSS) vulnerabilities (if added).

### Processing with Nuclei

After gathering all necessary information, the script uses Nuclei with custom templates to scan for specific vulnerabilities:

- **alljs.txt** is scanned with JavaScript-related templates located at `/root/priv8-Nuclei/js/`.
- **fuzz.txt** is scanned with general templates located at `/root/priv8-Nuclei/`.

You can modify the paths to the Nuclei templates according to your setup.

## Example Run

Here is an example of how the script works:

1. Run the script:
   ```bash
   ./recon.sh example.com
   ```

2. The script will check for required tools. If any are missing, it will prompt you to install them.

3. The script will perform subdomain discovery, probe live domains, gather URLs, and store them in various output files.

4. The script will then use Nuclei to scan the gathered URLs for potential vulnerabilities.

5. After completion, you will find the following files in the target directory:
   - `alljs.txt`
   - `allurls.txt`
   - `fuzz.txt`
   - `live.txt`
   - `subdomain.txt`

## Customization

You can customize the script by:
- Adding additional tools to the `tools` array.
- Modifying the Nuclei template paths.
- Adding new output files and processing steps.

## Troubleshooting

If the script fails to run or tools are not installed correctly:
- Ensure `GOPATH` is set up correctly for `go install` commands.
- Verify that the required tools are correctly installed in the system's `$PATH`.
- Check file permissions to ensure the script can create directories and write files.

## Conclusion

This automated reconnaissance tool streamlines the process of gathering information and scanning for vulnerabilities. By ensuring all necessary tools are installed and configured, it provides a robust framework for security testing.
