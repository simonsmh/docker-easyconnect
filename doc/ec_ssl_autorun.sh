#!/bin/bash
DELAY=8
Regex='\[Register\]cms client connect failed'
ECLogFile=/usr/share/sangfor/EasyConnect/resources/logs/ECAgent.log
SSLScript=/usr/share/sangfor/EasyConnect/resources/shell/sslservice.sh
while true
do
	[ -e "$ECLogFile" ] && (tail -n 0 -f "$ECLogFile" | grep -m 1 -e "$Regex") && "$SSLScript"
	sleep "$DELAY"
done

