#!/bin/bash

awk -v RS= '{print > ("tmp_day1_elf_" NR ".txt")}' $1
calories_sum=$(
    for f in tmp_day1_elf* 
    do
        awk '{sum+=$1} END {print sum}' $f
    done
)

IFS=$'\n'
echo "${calories_sum[*]}" | sort -n | tail -n1
rm tmp*
