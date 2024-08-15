#!/bin/bash
target=$1
mkdir $1
cd $1
subfinder -d $1 -all -recursive > subdomain.txt
httpx -l subdomain.txt -o live.txt 
katana -u live.txt -d 5 -ps -pss waybackarchive,commoncrawl,alienvault -kf -jc -fx -ef woff,css,png,svg,jpg,woff2,jpeg,gif,svg -o allurls.txt
cat allurls.txt | grep -iE "\.js$" >> alljs.txt
cat allurls.txt | grep -iE 'Image_url=|Open=|callback=|cgi-bin/redirect\.cgi|cgi-bin/redirect\.cgi\?|checkout=|checkout_url=|continue=|data=|dest=|destination=|dir=|domain=|feed=|file=|document=|folder=|root=|path=|pg=|style=|pdf=|template=|php_path=|doc=|page=|name=|cat=|dir=|action=|board=|date=|detail=|download=|prefix=|include=|inc=|locate=|show=|site=|type=|view=|content=|layout=|mod=|conf=|url=|val=|validate=|window=' >lfi.txt
cat allurls.txt | grep -iE 'Image_url=|Open=|callback=|cgi-bin/redirect\.cgi|cgi-bin/redirect\.cgi\?|checkout=|checkout_url=|continue=|data=|dest=|destination=|dir=|domain=|feed=|file=|document=|folder=|root=|path=|pg=|style=|pdf=|template=|php_path=|doc=|page=|name=|cat=|dir=|action=|board=|date=|detail=|download=|prefix=|include=|inc=|locate=|show=|site=|type=|view=|content=|layout=|mod=|conf=|url=|val=|validate=|window=' >redir.txt
cat allurls.txt | grep -iE 'q=|s=|search=|lang=|keyword=|query=|page=|keywords=|year=|view=|email=|type=|name=|p=|callback=|jsonp=|api_key=|api=|password=|email=|emailto=|token=|username=|csrf_token=|unsubscribe_token=|id=|item=|page_id=|month=|immagine=|list_type=|url=|terms=|categoryid=|key=|l=|begindate=|enddate=' >xss.txt
cat allurls.txt | grep -iE 'id=|select=|report=|role=|update=|query=|user=|name=|sort=|where=|search=|params=|process=|row=|view=|table=|from=|sel=|results=|sleep=|fetch=|order=|keyword=|column=|field=|delete=|string=|number=|filter=' >sqli.txt
nuclei -l /home/learn/Desktop/BUG/$1/xss.txt   -t /root/fuzzing-templates/xss/ -dast
nuclei -l /home/learn/Desktop/BUG/$1/sqli.txt   -t /root/fuzzing-templates/sqli/ -dast
nuclei -l /home/learn/Desktop/BUG/$1/redir.txt   -t /root/fuzzing-templates/redirect/ -dast
nuclei -l /home/learn/Desktop/BUG/$1/lfi.txt   -t /root/fuzzing-templates/lfi/ -dast
