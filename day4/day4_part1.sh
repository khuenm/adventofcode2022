#!/bin/bash

cp $1 tmp_day4

sed -i'' -e "s/,/ /g" tmp_day4
sed -i'' -e "s/-/ /g" tmp_day4

cat tmp_day4 |
awk '
BEGIN{FS=" "} 
{if ($1 <= $3 && $2 >= $4) {$5=1}
else if ($1 >= $3 && $2 <= $4) {$5=1}
else {$5=0}
}1' | 
cut -d" " -f5 |
awk '{s+=$1} END {print s}'

rm tmp*
