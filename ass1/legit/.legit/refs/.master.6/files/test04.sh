#!/bin/sh
#check status
./legit.pl init
echo line 1 >a
./legit.pl add a
./legit commit -m "first commit"
echo line 2 >>a
./legit.pl commit -a -m "second commit"
seq 1 3 >c
./legit.pl add c
./legit.pl commit -m "third commit"
echo line 3 >d
echo line 4 >b
./legit.pl add b
./legit.pl status
