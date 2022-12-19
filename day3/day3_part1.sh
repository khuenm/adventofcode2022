#!/bin/bash

# ord() - converts ASCII character to its decimal value
# https://unix.stackexchange.com/questions/92447/bash-script-to-get-ascii-values-for-alphabet
ord() {
  # POSIX
  LC_CTYPE=C printf %d "'$1"
}

# Finding common char in substring
# https://stackoverflow.com/questions/6941924/how-do-i-find-common-characters-between-two-strings-in-bash
findCommonChars() {
    commonChars=$(
      comm -12 <(
        fold -w1 <<< "$1" |
          sort -u
          ) <(
            fold -w1 <<< "$2" |
              sort -u
              ) |
                tr -d \\n
                )
    echo ${commonChars[0]}
}

prioritizedItems=$(
    while IFS= read -r rucksackItem 
    do
        l=${#rucksackItem}
        firstHalf=${rucksackItem:0:$l/2}
        secondHalf=${rucksackItem:$l/2}
        commonChars=$(findCommonChars "$firstHalf" "$secondHalf")
        commonChar=${commonChars[0]}
        charASCII=$(ord $commonChar) 
        case $commonChar in
            ([[:upper:]]) echo $((charASCII-65+27));;
            ([[:lower:]]) echo $((charASCII-97+1));;
        esac
    done < $1
)
printf '%s\n' "${prioritizedItems[@]}" | 
awk '{s+=$1} END {print s}'
