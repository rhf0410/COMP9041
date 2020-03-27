#!/bin/sh
#check branch function
./legit.pl init
echo line 1 >a
./legit.pl add a
./legit.pl commit -m "first commit"
./legit.pl branch b1
./legit.pl branch b2
./legit.pl branch
./legit.pl branch -d b1
./legit.pl branch
./legit.pl branch master
