#!/usr/bin/env bash

FILE=/tmp/.txt

handleLine () {
    echo "Processing: ${1}"
}

while read -r line; do
    handleLine "$line"
done < $FILE