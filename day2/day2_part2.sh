#!/bin/bash

cp $1 tmp_day2

declare -a opponentMap=( 'A' 'B' 'C' )
for opponentNum in {1..3}
do
    sed -i'' -e "s/${opponentMap[$opponentNum-1]}/$opponentNum/" tmp_day2
done

declare -A resultMap=( ['X']=0 ['Y']=3 ['Z']=6 )
for resultChar in "${!resultMap[@]}"
do 
    sed -i'' -e "s/$resultChar/${resultMap[$resultChar]}/" tmp_day2 
done

cat tmp_day2 |
awk '
BEGIN{FS=OFS=" "} 
{player=($1+($2/3)-1) % 3}
{if (player==0) {$3=3} 
else {$3=player}
}1' |
cut -d" " -f2,3 |
awk '{for(i=t=0;i<NF;) t+=$++i; $0=t}1' |
awk '{s+=$1} END {print s}'

rm tmp*
