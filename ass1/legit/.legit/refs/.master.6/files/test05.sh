#!/bin/sh
#check rm functions
./legit.pl init
echo 1 >a
echo 2 >b
./legit.pl add a b
./legit.pl commit -m "first commit"
./legit.pl rm a
seq 1 8 >c
seq 1 9 >d
./legit.pl add c d
./legit.pl commit -m "second commit"
./legit.pl rm --cached c
./legit.pl rm --force --cached d
seq 1 3 >e
./legit.pl add e
./legit.pl commit -m "third commit"
./legit.pl rm e
