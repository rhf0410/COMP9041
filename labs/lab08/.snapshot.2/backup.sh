#!/bin/sh

if [[ $1 =~ [0-9]$ ]]
then
    num=$(echo $1 | cut -d'.' -f3)
    num=$(expr $num + 1)
    file1=$(echo $1 | sed 's/[0-9]//g')
    newfile=${file}"$num"
else
    ofile=$1
    newfile="."${ofile}".0"
fi
while [[ -f "$newfile" ]]
do
    num=$(echo $newfile | cut -d'.' -f4)
    num=$(expr $num + 1)
    file1=$(echo $newfile | sed 's/[0-9]//g')
    newfile=${file1}"$num"
done
touch $newfile
while read line
do
   echo $line >> $newfile
done < $1
echo "Backup of '$1' saved as '$newfile'"
