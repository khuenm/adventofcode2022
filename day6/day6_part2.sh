#!/bin/bash

signal=$(cat $1)
n_char=${#signal}

for (( i=1; i<=$(( n_char-14 )); ++i ))
do
    if ! (echo ${signal:i:14} | grep -q '\(.\).*\1')
    then
        echo $(( i+14 ))
        break
    fi
done
