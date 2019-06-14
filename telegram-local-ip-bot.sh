#!/bin/bash

//This is a telegram bot which sends you updates of your network devices.
//The bot informs you when a divice leves or enters your network.

//save the current path as your working path
dir=$(pwd);

//Your Network IP and Subnet, count the devices
current_ips=$(nmap -sP 192.168.2.0/24 | sed -n '/192.168.2/p' | wc -l);
//check the last devices
last_ips=$(tail -n1 "$dir/ip_counter.txt");

#YOUR Telegram API Creedentials
TOKEN=123456789:AABBCCDDEEFF001122334455-6677889900
CHAT_ID=-123456789

URL="https://api.telegram.org/bot$TOKEN/sendMessage"

if [ ! -f "$dir/ip_counter.txt" ]; then
  echo $current_ips > "$dir/ip_counter.txt";
fi

sendMessage () {
        curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$1";
        echo $current_ips > "$dir/ip_counter.txt";
}

res=`expr $last_ips - $current_ips`;
res=${res#-};

if [ $current_ips -gt $last_ips ]; then
        sendMessage "es sind $res Geräte in das Netzwerk hinzugekommen";
elif [ $current_ips -le $last_ips ]; then
        sendMessage "es haben $res Geräte das Netzwerk verlassen";
fi

//if there is any parameter send an telegram message anyhow
if [ $# -gt 0  ]; then
        sendMessage "es befinden sich $res Geräte im Netzwerk";
fi
