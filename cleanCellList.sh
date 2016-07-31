#!/bin/bash -e
#Delete all the directories included in the cellList

# declare -a cellList=(
#  	"AND3X1TL"
# 	"AND3X2TL"
#  	"AND3X4TL"
#  	"AND3X6TL"
#  	"AND3X8TL"
# )

#Read new line separated list.
#Read file into an array. Must be separted by newlines.
readarray -t cellList < ./cellList.list

#Print cellList new line separated
# printf '%s\n' "${cellList[@]}"

cellCount=${#cellList[@]}

printf "Deleting %d\n" "${cellCount}"
echo "${cellList[*]}" | tee cellList.txt

for i in "${cellList[@]}" ;
do
    echo "Deleting ${i}"
    (rm -Rf ./"${i}" &)
done
