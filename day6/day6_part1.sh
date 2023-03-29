#!/bin/bash

signal=$(cat $1)
n_char=${#signal}

for (( i=1; i<=$(( n_char-4 )); ++i ))
do
    if ! (echo ${signal:i:4} | grep -q '\(.\).*\1')
    then
        echo $(( i+4 ))
        break
    fi
done
