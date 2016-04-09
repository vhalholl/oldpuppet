#!/bin/bash
if [[ ! -z $1 ]];then
[[ $(echo -e "HEAD / HTTP/1.1\r\nHost:$1\r\nUser-Agent: zabbix-server/prod externalscripts/$1\r\n\r\n" |nc $1 80 |head -n 1|cut -d " " -f2  |grep '200\|302') ]]&& echo 0 ||echo 1
fi
