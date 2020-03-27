#!/bin/sh
#check show function
./legit.pl init
seq 1 3 >a
./legit.pl add a
./legit.pl commit -m commit-0
perl -pi -e 's/2/6/' a
./legit.pl add a
./legit.pl commit -m commit-1
./legit.pl show 0:a
./legit.pl show 1:a
./legit.pl show :a
