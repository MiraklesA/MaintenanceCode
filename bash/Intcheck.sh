#!/bin/bash

while true; do #While loop declared to allow for a continious loop until conditions are met. 
  read -p "Enter a two digit numeric code (Integer) that is either equal to 20 or equal to 40: " int #User Input
  if [[ $int =~ ^[0-9]+$ ]]; then #If variable that only accepts integers
      if [[ $int =~ 20 || $int =~ 40 ]]; then #If variable that detects if the integer is = "20" or "40"
          echo "Congrats on entering the correct code"
          break #If input is int and equal to 20 or 40, breaks out of the loop

      else 
          echo "You've failed to enter the correct code, please try again"
          #invalid code entered, will cause user ot loop back to the prompt
      
 
      fi

  else
      echo "You failed to insert a integer, please try again"
      #integer not entered will cause user to loop back to the prompt
  fi 


done


exit 0 
    


