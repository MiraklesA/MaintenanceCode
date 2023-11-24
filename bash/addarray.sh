#!/bin/bash

counter=0 
sum=0
declare -a ass1
ass1=(12 18 20 10 12 16 15 19 8 11)

declare -a ass2 
ass2=(22 29 30 20 18 24 25 26 29 30)

declare -a sum 
sum=()
#Preset variables and arrays declared. 

for i in "${!ass1[@]}"; #For loop for every variable within array 1 
do 
  sum[i]=$(( ${ass1[i]} + ${ass2[i]} )) #For every variable within array one it will combine with every individual varriable in array 2 to create another final array. 

done 

for i in "${!sum[@]}"; #For every varriable within this array that contains the sum of array one and two. It will repeat this loop. 
do
     counter=$((counter+1)) #For every time the loop is repeated the counter will increase by one 
     echo "Student_$counter Result:   ${sum[i]}" #Student results plus their associated sum will be echo'd to the terminal 
done

exit 0 
