#!/bin/bash

EMAIL="abhijeet444rana@gmail.com"
CC_EMAIL="abhijeet4rana@gmail.com"
SUBJECT="Disk Space Alert"

DISK_SPACE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

THRESHOLD=15

if [ "$DISK_SPACE" -gt "$THRESHOLD" ]; then
    MESSAGE="Disk space usage is at $DISK_SPACE%. It has exceeded the threshold of $THRESHOLD%. Please check and free up some space sent using sendmail."
    
    echo -e "Subject: $SUBJECT\nTo: $EMAIL\nCc: $CC_EMAIL\n\n$MESSAGE" | sendmail -t
else
    echo "Disk space usage is at $DISK_SPACE%. Everything is within the threshold."
fi
