#!/bin/bash

read source
read backup
read file_extn

cnt=$(find "$source" -maxdepth 1 -type f -name "*.$file_extn" | wc -l)

arr=("$source"/*."$file_extn")
shopt -u nullglob

echo "Count: $cnt"
export cnt

echo "Files in source:"
for file in "${arr[@]}"; do
    echo "$file"
done

if [ -d "$backup" ]; then
    echo "Backup path exists"

    arr_new=("$backup"/*."$file_extn")

    echo "Files in backup before copy:"
    for file in "${arr_new[@]}"; do
        echo "$file"
    done

    echo "Copying files..."
    for file in "${arr[@]}"; do
        cp "$file" "$backup"
    done

    cnt_backup=$(find "$backup" -maxdepth 1 -type f -name "*.$file_extn" | wc -l)
    echo "Backed Up Files Count: $cnt_backup"
    
    total_size=$(du -sh "$backup")
    echo "Total size of the backup dir: $total_size"

else
    echo "Backup path does not exist"
fi

#Inputs:
#/home/kishore/Desktop/EmbedUR Linux Assessments/Module - 3
#/home/kishore/Desktop
#sh


