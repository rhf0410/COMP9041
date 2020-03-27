#!/bin/sh
#check branch and checkout functions.
./legit.pl init
echo line 1 >a
./legit.pl add a
./legit.pl commit -m "first commit"
echo line 2 >>a
./legit.pl branch b1
./legit.pl add a
./legit.pl commit -m "second commit"
./legit.pl branch b2
seq 1 8 >b
./legit.pl add b
./legit.pl commit -m "third commit"
./legit.pl checkout master
./legit.pl checkout b1
