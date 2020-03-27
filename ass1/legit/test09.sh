#!/bin/sh
#check merge function
./legit.pl init
seq 1 10 >a
./legit.pl add a
./legit.pl commit -m "first commit"
seq 1 12 >b
./legit.pl add b
./legit.pl commit -m "second commit"
./legit.pl branch b1
perl -pi -e 's/6/24/' a
./legit.pl commit -a -m "third commit"
./legit.pl branch b2
perl -pi -e 's/4/34/' a
./legit.pl commit -a -m "fourth commit"
./legit.pl checkout master
./legit.pl merge b1 -m merge-1
./legit.pl merge b2 -m merge-2
cat a
