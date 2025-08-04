#!/bin/sh
if [ -z "$( ls -A $1 )" ]; then
   echo 0
else
   echo "Not empty"
fi
