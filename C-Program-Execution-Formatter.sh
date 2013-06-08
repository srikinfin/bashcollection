#!/bin/bash
#Program to recieve C source code and output them directly 
#in single step

#Shows the Command to be executed and the output together
#set -x

#echo 
#echo $*

options=$*

vim /home/ennova/$options.c;
#echo /////////////////// C Program compilation \\\\\\\\\\\\\\\\\\  
echo
echo Compiling $options.c to $options
gcc $options.c -o $options; 
echo Adding execute permission to $options
chmod a+x $*; 
echo The Output:
echo ------------------------------------------------------------
./$*
echo ------------------------------------------------------------
#echo `//////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\`
