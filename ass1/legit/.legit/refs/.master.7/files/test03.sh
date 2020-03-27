#!/bin/sh
#check log function
./legit.pl init
seq 1 5 >a
seq 2 10 >b
./legit.pl add a b
./legit.pl commit -m commit-0
seq 1 4 >c
./legit.pl add c
./legit.pl commit -m commit-1
seq 1 8 >d
./legit.pl add d
./legit.pl commit -m commit-2
./legit.pl log

