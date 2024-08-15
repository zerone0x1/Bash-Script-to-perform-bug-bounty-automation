#coffinsp  methodology &priv8-Nuclei templete
#!/bin/bash
target=$1
mkdir $1
cd $1
subfinder -d $1 -all -recursive > subdomain.txt
httpx -l subdomain.txt -o live.txt 
katana -u live.txt -d 5 -ps -pss waybackarchive,commoncrawl,alienvault -kf -jc -fx -ef woff,css,png,svg,jpg,woff2,jpeg,gif,svg -o allurls.txt
cat allurls.txt | grep '=' >fuzz.txt
cat allurls.txt | grep -iE "\.js$" >> alljs.txt
nuclei -l /home/learn/Desktop/BUG/$1/alljs.txt   -t /root/priv8-Nuclei/js/
nuclei -l /home/learn/Desktop/BUG/$1/fuzz.txt   -t /root/priv8-Nuclei/
