#!/bin/bash -e
#Netlist all the cells on the cellList

# declare -a cellList=(
# 	"AND3X1TL"
# 	"AND3X2TL"
# 	"AND3X4TL"
# 	"AND3X6TL"
# 	"AND3X8TL"
# )

#Read new line separated list.
#Read file into an array. Must be separted by newlines.
readarray -t cellList < cellList.list

#Print cellList new line separated
# printf '%s\n' "${cellList[@]}"

cellCount=${#cellList[@]}

printf "Netlisting %d\n" "${cellCount}"

for i in "${cellList[@]}";
do
	echo "Netlisting ${i}"

    (cd ./"${i}"; ./runNetlist.sh | tee ./netlist.log &)

done
