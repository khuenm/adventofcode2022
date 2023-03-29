#!/bin/bash

line_separator_idx=$(awk '! NF { print NR; exit }' $1)
n_stacks=$(sed "$((line_separator_idx - 1))q;d" $1 | rev | cut -d' ' -f2)

tail -n +$((line_separator_idx + 1)) $1 | awk '{print $2,$4,$6}' > tmp_day5_instruction

# Fill space with 1 to not mess up with columns of different height
head -n $((line_separator_idx - 2)) $1 |
    sed 's/\[/ /g' |
    sed 's/\]/ /g' |
    sed 's/ /1/g' > tmp_day5_all_stacks

# Iterate through each row and each column to parse all non-1 chars
while IFS=' ' read -r curr_line
do
    for (( col_idx=1; col_idx<=$n_stacks; ++col_idx ))
    do
        curr_idx=$(( 1 + 4*(col_idx-1) ))
        curr_char=${curr_line:$curr_idx:1}
        if [ $curr_char != "1" ]
        then 
            echo $curr_char >> tmp_day5_stack_$col_idx
        fi
    done
done < tmp_day5_all_stacks

# Flip all stacks for easier operations
for (( i=1; i<=$n_stacks; ++i ))
do
    tac tmp_day5_stack_$i > tmp_move && mv tmp_move tmp_day5_stack_$i
done

while IFS=' ' read -r num from to
do
    tail -n $num tmp_day5_stack_$from | tac >> tmp_day5_stack_$to
    tac tmp_day5_stack_$from | tail -n +$(($num + 1)) | tac > tmp_move && mv tmp_move tmp_day5_stack_$from
done < tmp_day5_instruction

res=$(
    for ((i=1; i<=$n_stacks; ++i))
    do
        tail -n1 tmp_day5_stack_$i
    done
)

echo $res | sed 's/ //g'
rm tmp*
