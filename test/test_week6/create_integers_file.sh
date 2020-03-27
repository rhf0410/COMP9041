#!/bin/sh

i=$1
touch $3
while(( $i <= $2 ))
do
    echo $i >> $3
    let "i++"
done
