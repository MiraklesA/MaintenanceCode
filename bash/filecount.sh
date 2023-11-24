#!/bin/bash
#This program can count any directiories / data just the full path needs to be specified by user input

FileC=0
DirectoryC=0
emptyfileC=0
emptydirectoryC=0
directory=${1:-.}
#All the preset varriables and arrays created
shopt -s nullglob
#Using shell nullglob options to ensure data accuracy. 



for directory in $1/* #For loop that repeats for the inputted directory
do
if [ -d $directory ]; then #Searches for directorys
  
  DirectoryC=$[$DirectoryC+1] #If a directory is found it adds + 1 to the total in the counter
  Total=($directory/*)
  
  if [ ${#Total[*]} -eq 0 ]; then
      emptydirectoryC=$[$emptydirectoryC+1] #Increasing the counter once a empty directory is found. 
   else 
     continue 

   fi
else
  FileC=$[$FileC+1] #Other data within the directory will be files , which is why an else command is used. 

  if [ ! -s $directory ]; then #Used to specificy if the file is empty within the directory
  emptyfileC=$[$emptyfileC+1] #The counter increases by 1
  fi
fi
done #end of loop






shopt -u nullglob
totalF=$((FileC - emptyfileC)) #Subtracting total files - the empty files to get the total number of files that contained data
totalD=$((DirectoryC - emptydirectoryC)) #Subtracting the total directories to the empty directories to get the total number of directiories that contained data. 
echo "The $1 contains"
echo "Files with data counted = $totalF"
echo "Empty Folders = $emptyfileC"
echo "Directory with data = $totalD"
echo "Empty Directory = $emptydirectoryC"
#All printed to the terminal for the user

exit 0 
