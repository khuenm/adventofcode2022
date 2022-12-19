#!/bin/bash

cp $1 tmp_day2

declare -a opponentMap=( 'A' 'B' 'C' )
for opponentNum in {1..3}
do
    sed -i'' -e "s/${opponentMap[$opponentNum-1]}/$opponentNum/g" tmp_day2
done

declare -a playerMap=( 'X' 'Y' 'Z' )
for playerNum in {1..3}
do
    sed -i'' -e "s/${playerMap[$playerNum-1]}/$playerNum/" tmp_day2
done

cat tmp_day2 |
awk '
BEGIN{FS=OFS=" "} 
{result=$2-$1} 
{if (result==-2 || result==1) {$3=6} 
else if (result==0) {$3=3}
else {$3=0} 
}1' | 
cut -d" " -f2,3 |
awk '{for(i=t=0;i<NF;) t+=$++i; $0=t}1' |
awk '{s+=$1} END {print s}'

rm tmp*
