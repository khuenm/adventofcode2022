#!/bin/bash

MIN_OCCUPIED_SPACE=40000000
START_DIR=$PWD

# Parse directory structure and write file "size" to file
while read -r -a line
do
    if [ ${line[0]} == "$" ]; then
        if [ ${line[1]} == "cd" ]; then
            if [ ${line[2]} == "/" ]; then
                mkdir tmp
                cd tmp
            elif [ ${line[2]} == ".." ]; then
                cd ..
            else
                cd ${line[2]}
            fi
        fi
    elif [ ${line[0]} == "dir" ]; then 
        mkdir ${line[1]}
    else
        echo ${line[0]} > ${line[1]}
    fi
done < $1

cd $START_DIR
find tmp -type d -ls | awk '{print $NF}' > tmp_all_dirs
total_size=$(find tmp -type f -exec cat {} + | awk '{SUM+=$1}END{print SUM}') 
min_size_to_delete=$total_size

while read -r curr_dir
do
    curr_size=$(find $curr_dir -type f -exec cat {} + | awk '{SUM+=$1}END{print SUM}') 
    if [ $(( total_size-curr_size )) -le $MIN_OCCUPIED_SPACE ] && [ $curr_size -lt $min_size_to_delete ]; then
        min_size_to_delete=$curr_size
    fi
done < tmp_all_dirs

echo $min_size_to_delete
rm -r tmp*
