#!/bin/bash

# Check if crunch is installed
if ! command -v crunch &> /dev/null; then
    echo "Crunch is not installed. Installing now..."
    sudo apt-get update && sudo apt-get install crunch -y
    if ! command -v crunch &> /dev/null; then
        echo "Failed to install Crunch. Exiting..."
        exit 1
    fi
fi

again="1"

while [ "$again" = "1" ]; do 
    read -p "Enter minimum length : " min
    read -p "Enter maximum length : " max
    read -p "Enter all the characters you want to include : " str
    read -p "Enter the file name of combinations : " fileName

    crunch $min $max "$str" -u | head -n 0

    read -p "Enter 1 to continue or anything other than 1 to exit : " input

    if [ "$input" = "1" ] 
    then
        crunch $min $max "$str" > "$fileName"
        
        echo "Wordlist created in file named as $fileName. " 
        read -p "Do you want to compress the wordlist ? zip/tar/n : " option
        
        if [ "$option" = "zip" ]; then
            zip "$fileName.zip" "$fileName"
            echo "$fileName is compressed as ZIP "
        elif [ "$option" = "tar" ]; then
            tar -czf "$fileName.tar.gz" "$fileName"
            echo "$fileName is compressed as TAR "
        fi
        
        read -p "Do you want to delete the original file ? y/n : " delete
        
        if [ "$delete" = "y" ]; then
            rm "$fileName"
            echo "$fileName deleted "
        fi
    else
        echo "Exiting ... "
        exit 0
    fi	
    
    read -p "Enter 1 to create another wordlist or anything other than 1 to exit : " again
done
