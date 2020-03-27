#!/bin/sh

suffix="(\.htm)$"
newsuffix="html"
for file in *;
do
if [[ "$file" =~ $suffix ]]
then
    newfile=$(echo "$file" | cut -d'.' -f1)
    nnewfile="$newfile"."$newsuffix"
    if [ -f "$nnewfile" ]
    then
        echo "$nnewfile exists"
        exit 1
    else
        mv "$file" "$nnewfile"
    fi
fi
done
