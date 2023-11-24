#!/bin/bash

getprop() {  #getprop is the main function this script will be using to find out the details regarding the folder. 
    filesize=$(du -k "$1" | cut -f 1)    #Uses du command in order to find out the file size of the document, cut is used to remove any unwanted data. 

    wordcount=$(wc -w "$1" | cut -c 1)  #We use the word count command to identify the amount of words within the file, using the cut command again to remove any unwanted varibales. 
       
    date=$(stat -c '%y' "$1" | cut -f 1) #We use the stat command to find out the date the folder was last modified and import it into this variable. Cut command is again used to remove any unwanteddata
    
    echo "The file $1 contains $wordcount words and is $filesize kilobytes in size and was last modified $date" #data is echo'd out in correct format. 

}


read -p 'Enter folder name: ' sfold #read command asks for user input and connects it to the sfold varriable. 
getprop $sfold #Function is called to run using the sfold varriable. So $1 = $sfold
exit 0 
