#!/bin/sh

n=2
if [ $# -ne $n ]
then
    echo 'Usage: ./echon.sh <number of lines> <string>'
    exit 1
fi

if [[ $1 =~ ^-[0-9]+$ ]] || [[ $1 =~ [^0-9] ]]
then
    echo './echon.sh: argument 1 must be a non-negative integer'
    exit 1
fi

i=1
while(( $i<=$1 ))
do
    echo $2
    let "i++"
done
