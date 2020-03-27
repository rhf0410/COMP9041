#!/bin/sh
#check commit -a and rm function
./legit.pl init
seq 1 8 >a
./legit.pl add a
./legit.pl commit -m commit-0
seq 1 13 >a
./legit.pl commit -a -m commit-1
seq 1 4 >b
./legit.pl add b
./legit.pl commit -m commit-2
./legit.pl rm b

