#!/bin/sh

fir=$1
text=$(wget -q -O- "http://www.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=${fir:0:1}"|grep $1| sed -e 's/<[^>]*>//g')

text2=$(wget -q -O- "http://www.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=${fir:0:1}"|grep $1| sed -e 's/<[^>]*>//g')

i=0
str=()
for line in $text
do
    if [[ "$line" =~  $1[0-9]{4} ]]; then
        if [ $i == 0 ]
        then
            printf "%s " $line
            str+=$line
            ((i++));
        else
            printf "\r\r\n"
            printf "%s " $line
            str+=$line
        fi
    else 
        printf "%s " $line
    fi
done
for line in $text2
do
    if [[ "$line" =~ $1[0-9]{4} ]]
    then
        printf "\r\r\n"
        printf "%s " $line
    else
        printf "%s " $line
    fi
done
printf "\n"
