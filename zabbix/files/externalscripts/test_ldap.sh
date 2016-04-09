#!/bin/bash
if [[ ! -z $1 ]];then
[[ $(ldapsearch -h $1 -s one -x -b dc=domain,dc=fr '(dc=domain.tld)' 2>/dev/null | grep 'numEntries\|numResponses' |cut -d ' ' -f3) == 1 ]] && echo 0 || echo 1 
fi
