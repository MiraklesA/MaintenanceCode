#!/bin/bash
awk 'BEGIN { FS="[[:space:]]";} 
     NR>1 {
            if (length($2) >= 8 && $2 ~ "[[:digit:]]" && $2 ~ "[[:upper:]]")
              {
                printf"" $2 " - meets password strength requirements"
                printf")\n";
              }
            else 
                {
                 printf"" $2 " - does not meet the password strength requirements"
                 printf")\n";

                }
         }
        


     END {print "End of Password Check"}' usrpwords.txt

#Awk code is used to create a if structured loop for every line within usrpwords.txt 
#After reading the second variable that is identified thanks to the IFS, AWK determines if it meets the password criter thanks to the length / digit and upper case command
#If The password meets those requirements awk prints it so, if it doesnt the code acknowledges it aswell. 
     
exit 0 
