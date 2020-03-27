#!/bin/sh
#check subset0 functions.
./legit.pl init
echo line 1 >a
echo line 2 >b
./legit.pl add a b
./legit.pl commit -m commit-0

