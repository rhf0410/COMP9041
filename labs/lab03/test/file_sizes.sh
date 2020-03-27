#!/bin/sh

Small=()
Medium=()
Large=()

for file in *
do
    num=$(wc -l $file|cut -d' ' -f1)
    name=$(wc -l $file|cut -d' ' -f2)
    if [ $name = 'file_sizes.sh' ]
    then 
        continue
    fi
    if [ $num -lt 10 ]
    then
       Small+=($name)
    elif [ $num -lt 100 ]
    then 
        Medium+=($name)
    else
        Large+=($name)
    fi
done

echo "Small files: ${Small[@]}"
echo "Medium-sized files: ${Medium[@]}"
echo "Large files: ${Large[@]}"
