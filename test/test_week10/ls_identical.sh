#!/bin/sh

cd $1
sf=""
for file in *
do
    cd ..
    if [ -f "$2/$file" ];
    then
        diff $1"/""$file" $2"/""$file" >/dev/null
        if [ $? == 0 ];
        then
            sf="$sf$file*"
        fi
    fi
    cd $1    
done
if [ -n "$sf" ];
then
    echo "$sf" | sed 's/[*]$//g' | tr '*' '\n' | sort
fi
