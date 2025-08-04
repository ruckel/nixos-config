#!/bin/sh

setterm -linewrap off
echo -e "
\e[36m


 Search:\e[35m
 $@\e[0m
"

grep -iE --color ".*$1.*\
 .*$2.*\
 .*$3.*\
 .*$4.*\
 .*$5.*\
 .*$6.*\
 .*$7.*\
 .*$8.*" /home/korv/scripts/nix/storeresult.txt 
#.*$9.*" 
#/home/korv/scripts/nix/storeresult.txt 

setterm -linewrap on
