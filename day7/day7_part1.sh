#!/bin/bash

MAX_FILE_SIZE=100000
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
total_size=0
while read -r curr_dir
do
    curr_size=$(find $curr_dir -type f -exec cat {} + | awk '{SUM+=$1}END{print SUM}') 
    if [ $curr_size -le $MAX_FILE_SIZE ]; then
        total_size=$(( total_size + curr_size ))
    fi
done < tmp_all_dirs

echo $total_size
rm -r tmp*
