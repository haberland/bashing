#!/bin/bash

#dir=$(pwd);
dir="/home"

ip_address=$(curl -s http://ifconfig.me);
ip_logfile="$dir/ip_logfile.txt";


#YOUR Telegram API Creedentials
TOKEN=123456789:AABBCCDDEEFF001122334455-6677889900
CHAT_ID=-123456789

URL="https://api.telegram.org/bot$TOKEN/sendMessage"


function sendMessage {
        curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$1";
}

function checkIP {
        if [ -f "$ip_logfile" ]; then
                last_ip=$(tail -n1 "$ip_logfile");

                if [ ! "$last_ip" = "$ip_address" ]; then
                        echo "$ip_address" >> "$ip_logfile";
                        sendMessage "VPN-Server hat eine neue IP ($ip_address)";
                fi
        else
                echo "$ip_address" >> "$ip_logfile";
                sendMessage "VPN-Server hat neue Logfile angelegt ($ip_address)";
        fi
}

if [ $# -gt 0  ]; then
        sendMessage "VPN-Server ist neugestartet ($ip_address)";
        checkIP
else
        checkIP
fi 
