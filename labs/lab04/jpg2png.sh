#!/bin/sh

for file in *.jpg
do
    if [ -f "${file%.jpg}".png ]
    then
        echo "${file%.jpg}".png already exists
    else
        convert "$file" "${file%.jpg}.png"
    fi
done
exit 0
