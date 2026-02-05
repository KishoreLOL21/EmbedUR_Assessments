#!/bin/bash

filename="/home/kishore/Downloads/input.txt"

#File existence Check
if [[ -e "$filename" ]]; then
	echo "File Exists"
else
	echo "Does not Exists"
fi

#Read the contents

content=$(cat "$filename")
j=0

while read line
do
    if [[ "$line" == *"frame.time"* || "$line" == *"wlan.fc.type"* || "$line" == *"wlan.fc.subtype"* ]]; then
    	echo $line    	
    	((j++))
    fi
done < $filename

echo "Number of Lines Fetched: $j"


