#!/bin/bash

pre="<tr><td>"
post="<\/td><\/tr>"
mid="<\/td><td>"
#Pre determined variables used to remove the most commond code associated within a HTML file, this is general variables that are commonly located within one. 
echo "Attacks         Instances(Q3)" #Header echo'd out. 
cat attacks.html | grep "<td>" | sed -e "s/^$pre//g; s/$post$//g; s/$mid/ /g" | awk '{total= ($2+$3+$4); printf $1"\t        %.1f\n", total}' 
#Cat used to find source document attacks.html, grep/sed used to identify and remove the html data associated with the varriables. Awk is then used to calculate the total of the attacks for ea
#Instance and prints it out under a neat header. 

exit 0 
