#!/bin/sh

TEMP1=/import/cage/3/z5184816/lab04/temp1

for image in $@
do
    ls -l ${image}>>$TEMP1
    month="$(ls -l temp1| cut -d' ' -f 6 | tail -n 1)"
    time="$(ls -l temp1| cut -d' ' -f 7 | tail -n 1)"
    day="$(ls -l temp1| cut -d' ' -f 8 | tail -n 1)"
    ptime=$month" "$time" "$day
    convert -gravity south -pointsize 36 -draw "text 0,10 '$ptime'" $image $image
done
