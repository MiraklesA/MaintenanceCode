#!/bin/bash
#Function at the start of the code that I will use to count, the total variables used
function ncount() {
  if [[ $total -eq 0 ]]; then 
    echo "No searches found"
    
  else 
     echo "A total of $total searches have been found"  

  fi
}

counter=0 #Counter for the amount of searches done
while true; do  #main loop for the code
if [[ $counter = 0 ]]; then #if the counter is zero then it will present a normal search message if its above zero it will give them the option to search again. 
  read -p "Enter [1] to Search or [2] to Exit: "
else 
  read -p "Enter [1] to Search Again or [2] to Exit: "
fi

if [[ $REPLY -eq 2 ]]; then #If reply is to exit then system will exit
   clear
   break 

elif [[ $REPLY -eq 1 ]]; then #If its 1 then the search procedure will commence
   clear 
   
   read -p 'What would you like to search?: ' search 
   read -p 'Would you like the whole word matched or any match on the line?(1/2): ' ch1
   read -p 'Would you want to do a inverted search?(1/2): ' ch2
  # Basic questions asked in regards to the criteria of the search , Yes = 1 , No = 2
         

   origifs=$IFS #Setting up the IFS 
   IFS='\n'
 
   echo "Search Results: "
   for line in $(cat access_log.txt); do #Another loop which repeats for every line in the txt file
      
      if [[ $ch1 == 2 ]] && [[ $ch2 == 2 ]]; then #If the user choice was no for both and search commences
       total="`grep -w -c -i "$search" access_log.txt`"
       ncount $total #recalls the function
       grep -n -w -i "$search" access_log.txt #Searches based on the search input provided by the user. 
      
        break 
      elif [[ $ch1 == 1 ]] && [[ $ch2 == 2 ]]; then #If USER opted 1 for the first option then the search criteria narrows and this section commences
        total="`grep -o -c -i -e "^$search$" access_log.txt`"
        grep -o -n -i "$search" access_log.txt  #Searchs based upon user input
        break 
      
      elif [[ $ch1 == 2 ]] && [[ $ch2 == 1 ]]; then #If user opted to have inverted search. 
        total="`grep -c -v -E -i "$search" access_log.txt`"
        ncount $total
        grep -n -v -E -i "$search" access_log.txt
        break

      elif [[ $ch1 == 1 ]] && [[ $ch2 == 1 ]]; then #If user opted to have both (Impossible criteria)
       total="`grep -o -c -v -E -i -n "^$search$" access_log.txt`"
       ncount $total
        grep -o -n -v -E -i "^$search$" access_log.txt 
        break
      
      else 
        echo "Invalid Input please try again" #If incorrect input was inserted then it will advise user and get them to start over. 
        break

      fi 
    done
else 
   echo "Invalid Input please try again" #If invalid input was detected it will get the user to start over
   ((counter++))
   continue 
   
fi
((counter++)) #Counter variable
IFS=$origifs


done 
exit 0  #Exit 
