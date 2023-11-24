#!/bin/bash


BSearch(){
grep -i -e "$sh1" $sel > tempfile.csv | sed -e 's/normal//g' | awk ' BEGIN {FS= "," }
      NR>1 { 
        printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
        }

END { print " REPORT END : "}' < tempfile.csv >$csel.csv
}
#Initial function to find details based off one search

Protocol(){
grep "suspicious" $sel > tempfile.csv 
awk ' BEGIN {FS= ","; ttlpackets=0; ttlbytes=0}
      NR>1 { 
           if ( $8 '"$seloper"' '"$value"' )
           {
                ttlpackets=ttlpackets+$8
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
           }
     }
END { print " REPORT END : ", ttlpackets }' < tempfile.csv >$csel.csv
}
#Initial Function to find packets and print the ones depending on the value given by the user

Protocol1(){
grep "suspicious" $sel > tempfile.csv 
awk ' BEGIN {FS= ","; ttlpackets=0; ttlbytes=0}
      NR>1 { 
           if ( $9 '"$seloper"' '"$value"' )
           {
                ttlpackets=ttlpackets+$9
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
           }
     }
END { print " REPORT END : ", ttlpackets }' < tempfile.csv >$csel.csv
}
#AWK function that automatically only uses lines that has "suspicious" within them and finds the total bytes

Protocol3(){

grep -i -e "$sh1" $sel > tempfile.csv | grep -i -e "$sh2" | sed -e 's/normal//g' | awk ' BEGIN {FS= ","; ttlpackets=0; ttlpackets2=0}
      NR>1 { 
           if (( '"$ch1"' == 6) && ( $8 '"$seloper"' '"$value"' ) || ( '"$ch1"' == 7) && ( $9 '"$seloper"' '"$value"' ))
           {
                ttlpackets=ttlpackets+$8
                ttlpackets2=ttlpackets2+$9
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
           }
           else if (( '"$ch2"' == 6)  || ( '"$ch2"' == 7) && ( $9 '"$seloper1"' '"$value1"' ))
           {
                ttlpackets=ttlpackets+$8
                ttlpackets2=ttlpackets2+$9
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
           }
           else if (( '"$ch1"' == 6 ) && ( '"$ch2"' == 7) && ( $9 '"$seloper"' '"$value"' ) && ( $8 '"$seloper1"' '"$value1"' ) || ( '"$ch1"' == 7) && ( '"$ch2"' == 6) && ( $9 '"$seloper"' '"$value"' ) && ( $8 '"$seloper1"' '"$value1"' ))
              {
                ttlpackets=ttlpackets+$8
                ttlpackets2=ttlpackets+$9
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
                }

           else if (( '"$ch1"' != 7 ) && ( '"$ch1"' !=6 ) && ( '"$ch2"' !=6 ) && ( '"$ch2"' !=7 ))
           {
             printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
          
           }


     }
END { print " REPORT END : ", ttlpackets ttlpackets2 }' < tempfile.csv >$csel.csv
} #Multi-use function that calculates bite factors while taking into account all other forms of user input / $csel is the folder that the user saves the document into that is dependant on user input


Protocol4(){
 grep -i -e "$sh1" $sel > tempfile.csv | grep -i -e "$sh2" | grep -i -e "$sh3" | sed -e 's/normal//g' | awk ' BEGIN {FS= ","; ttlpackets=0; ttlbytes=0}
      NR>1 { 
           if (( '"$ch1"' == 6 ) && ( $8 '"$seloper"' '"$value"' ) || ( '"$ch1"' == 7 ) && ( $9 '"$seloper"' '"$value"' ))
           {
                ttlpackets=ttlpackets+$8
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
           }
           else if (( '"$ch2"' == 6 ) && ( $8 '"$seloper1"' '"$value1"' ) || ( '"$ch2"' == 7 ) && ( $9 '"$seloper1"' '"$value1"' ))
           {
                ttlpackets=ttlpackets+$9
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
           }
           else if (( '"$ch3"' == 6 ) && ( $8 '"$seloper2"' '"$value2"' ) || ( '"$ch3"' == 7 ) && ( $9 '"$seloper2"' '"$value2"' ))
           {
                ttlpackets=ttlpackets+$9
                printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 
           }

        
           else if (( '"$ch1"' != 7 ) && ( '"$ch1"' != 6 ) && ( '"$ch2"' != 6 ) && ( '"$ch2"' !=7  ) && ( '"$ch3"' !=6 ) && ( '"$ch3"' != 7 ))
           {
             printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
          
           }


     }
END { print " REPORT END : ", ttlpackets ttlpackets2 }' < tempfile.csv >$csel.csv 
}
#Final function that takes into account all forms of user input. 









declare -a logs #Declaring array logs
stand="serv_acc_log.+csv$" #variable for any files that starts with serv_acc_log
mennum=1  

for file in ./*; do 
     if [[ $file =~ $stand ]]; then 
          logs+=($(basename $file))
     fi
done  #Loop that names and lists any file that starts with serv_acc_log
count=${#logs[*]} 

counter=0  #counter used for search

while true; do  #main loop for the code
if [[ $counter = 0 ]]; then #if the counter is zero then it will present a normal search message if its above zero it will give them the option to search again. 
  read -p "Enter [1] to Search or [2] to Exit: "
else 
  read -p "Enter [1] to Search Again or [2] to Exit: "
fi

if [[ $REPLY -eq 2 ]]; then #If reply is -eq 2 then the search breaks out of the loop
   clear
   break 

elif [[ $REPLY -eq 1 ]]; then #If its 1 then the search procedure will commence
   clear 

    read -p "Please select how many fields you would like to search [1] , [2] , [3] " choice #Initial main sarch that is used to identify how many fiels the user would like to search with
     echo -e "The logs array contains $count files. \n" #echos out all the array files
        for file in "${logs[@]}"; do 
               echo -e "$mennum $file" 
               ((mennum++))
        done 
        echo -e "\t"
        read -p "Enter the file required Template: 'serv_acc_log********.csv': " sel #User types out document he would like to use
        echo "You have entered $sel " #confirmatione cho




    if [[ $choice -eq 1 ]]; then  #If the user slects one they need to choose what criteria they would like to search with
        echo "Please Select your search term"
        read -p "Protocol [1] SRC IP [2] SRC Port [3] DEST IP [4] DEST PORT [5] Packets [6] Bytes [7] " ch1
        

        if [[ $ch1 == 6 ]]; then
          read -p "Enter comparison value: " value
          read -p  "Enter '=' '!=' '>' '<' : " seloper
          read -p "Enter file output name: " csel
          Protocol $seloper
          #If user chooses 6 then it will ask them for a comparison value and file output name while running the function

        elif [[ $ch1 == 7 ]]; then
          read -p "Enter comparison value: " value
          read -p  "Enter '=' '!=' '>' '<' : " seloper
          read -p "Enter file output name: " csel
          Protocol1 $seloper
          #If user chooses 7 then it will ask them for a comparison value and file output name while running the function

        else 
          read -p "Search Term: " sh1
          read -p "Enter file output name: " csel
          BSearch $sel
          #If user doesn't sleect 6 or 7 it will only ask for a search term and the normal file output name that is used to dictate the files name
        fi



        
        



    elif [[ $choice -eq 2 ]]; then  #If they selected that they wanted to search for two terms
      echo "Please select your search terms"
      read -p "Protocol [1] SRC IP [2] SRC Port [3] DEST IP [4] DEST PORT [5] Packets [6] Bytes [7] " ch1
      if [[ $ch1 == 6 ]]; then
          read -p "Enter comparison value: " value
          read -p  "Enter '=' '!=' '>' '<' : " seloper
          #If user selected 6 prompts will collect rest of required data
          
        elif [[ $ch1 == 7 ]]; then
          read -p "Enter comparison value: " value
          read -p  "Enter '=' '!=' '>' '<' : " seloper
          
          #If user selected 7 prompts will collect rest of required data
          

        else 
          read -p "Search Term: " sh1
          #If they didnt select 6 or 7 then it will continue by asking for their search term. 
          
        fi
      
      read -p "Protocol [1] SRC IP [2] SRC Port [3] DEST IP [4] DEST PORT [5] Packets [6] Bytes [7] " ch2
      if [[ $ch2 == 6 ]]; then
          read -p "Enter comparison value: " value1
          read -p  "Enter '=' '!=' '>' '<' : " seloper1
          read -p "Enter file output name: " csel
          Protocol3 $seloper
          #If user selected 6 prompts will collect rest of required data and run the function

        elif [[ $ch2 == 7 ]]; then
          read -p "Enter comparison value: " value1
          read -p  "Enter '=' '!=' '>' '<' : " seloper1
          read -p "Enter file output name: " csel
          Protocol3 $seloper
          #If user selected 7 prompts will collect rest of required data and run the function


        else 
          read -p "Search Term: " sh2
          read -p "Enter file output name: " csel
          Protocol3 $sel
          #If user doesnt select 6 or 7 it will ask them for their search term and fileoutput name then it will function
        fi
      

      
      
     
        
     #If user selected search with three search terms
    elif [[ $choice -eq 3 ]]; then 
   echo "Please select your search terms"
    
      read -p "Protocol [1] SRC IP [2] SRC Port [3] DEST IP [4] DEST PORT [5] Packets [6] Bytes [7] " ch1 #Search Criteria Selected By User
      if [[ $ch1 == 6 ]]; then 
          read -p "Enter comparison value: " value
          read -p  "Enter '=' '!=' '>' '<' : " seloper
          #If user selected 6 prompts will collect rest of required data 
          
        elif [[ $ch1 == 7 ]]; then
          read -p "Enter comparison value: " value
          read -p  "Enter '=' '!=' '>' '<' : " seloper
          #If user selected 7 prompts will collect rest of required data 
          
          

        else 
          read -p "Search Term: " sh1
        #If user doesn't select 6 or 7 it will ask for a search term and record it under a variable
        fi
      
      read -p "Protocol [1] SRC IP [2] SRC Port [3] DEST IP [4] DEST PORT [5] Packets [6] Bytes [7] " ch2 #Second Search Criteria
      if [[ $ch2 == 6 ]]; then
          read -p "Enter comparison value: " value1
          read -p  "Enter '=' '!=' '>' '<' : " seloper1
        #If user selected 6 prompts will collect rest of required data 

        elif [[ $ch2 == 7 ]]; then
          read -p "Enter comparison value: " value1
          read -p  "Enter '=' '!=' '>' '<' : " seloper1
          #If user selected 7 prompts will collect rest of required data 
          

        else 
          read -p "Search Term: " sh2
          #If user doesn't select 6 or 7 it will ask for a search term and record it under a variable
          
        fi
      
      read -p "Protocol [1] SRC IP [2] SRC Port [3] DEST IP [4] DEST PORT [5] Packets [6] Bytes [7] " ch3 #Third Search Criteria
      if [[ $ch3 == 6 ]]; then
          read -p "Enter comparison value: " value2
          read -p  "Enter '=' '!=' '>' '<' : " seloper2
          read -p "Enter file output name: " csel
          Protocol4 $seloper
          #If user selected 6 prompts will collect rest of required data then runs the function

        elif [[ $ch3 == 7 ]]; then
          read -p "Enter comparison value: " value2
          read -p  "Enter '=' '!=' '>' '<' : " seloper2
          read -p "Enter file output name: " csel
          Protocol4 $seloper
          #If user selected 7 prompts will collect rest of required data then runs the function

        else 
          read -p "Search Term: " sh3
          read -p "Enter file output name: " csel
          Protocol4 $sel
          #If user doesn't sleect 6 or 7 then the function will be ran while asking for search term and output files name. 
        fi


    fi

fi
done 
exit 0 
#Exit once loop is broken. 
