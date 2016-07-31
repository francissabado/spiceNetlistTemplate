#!/bin/bash -e

# declare -a cellList=(
# 	"AND3X1TL"
# 	"AND3X2TL"
# 	"AND3X4TL"
# 	"AND3X6TL"
# 	"AND3X8TL"
# )

#Read new line separated list.
#Read file into an array. Must be separted by newlines.
readarray -t cellList < CORELIB_LP_LVT.list

#Print cellList new line separated
# printf '%s\n' "${cellList[@]}" > cellList.list

cellCount=${#cellList[@]}

# printf "Netlisting %d\n" "${cellCount}"

for i in "${cellList[@]}";
do
    if [ ! -e "./${i}/${i}.sp" ];
    then
        echo "Netlist does not exist for ${i}"
    fi
done
