#!/bin/sh
#check merge function.
./legit.pl init
seq 1 8 >a
./legit.pl add a
./legit.pl commit -m commit-0
./legit.pl branch b1
perl -pi -e 's/2/34/' a
./legit.pl add a
./legit.pl commit -m commit-1
./legit.pl checkout master
perl -pi -e 's/5/32/' a
./legit.pl commit -a -m commit-1
./legit merge b1 -m merge-1
cat a 
