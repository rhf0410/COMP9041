#!/bin/sh

for file in $@
do
    cfile=$(cat $file | egrep "#include" | cut -d' ' -f2 | sed 's/"//g' | sed 's/<.*>//g')
    for newfile in $cfile
    do
        if [ ! -f "$newfile" ]
        then
           echo "$newfile included into $file does not exist"
        fi
    done
done
