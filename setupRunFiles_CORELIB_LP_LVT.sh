#!/bin/bash -e

#Change the settings here
CELL_LIBRARY="CORELIB_LP_LVT"
VIEW_NAME="cmos_sch"
TEMPLATE_DIR="netlistTemplate"

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
printf '%s\n' "${cellList[@]}" > cellList.list

cellCount=${#cellList[@]}

printf "Netlisting %d\n" "${cellCount}"

for i in "${cellList[@]}";
do
	#Copy templates
	rsync -ar --inplace ./"${TEMPLATE_DIR}"/ ./"${i}"
	# -r : recursive

	#Replace the following properties
	#simLibName = "${CELL_LIBRARY}"
	#simViewName = "${VIEW_NAME}"
	#simCellName = "${i}"
	#hnlNetlistFileName = "${i}.sp"
	echo "Setting up run directory for ${i}"

	#Using varibles in sed
	#http://unix.stackexchange.com/questions/148967/how-to-use-a-shell-variable-inside-seds-s-command
	(sed -i "
	s/^simLibName.*/simLibName = \"$(echo ${CELL_LIBRARY})\"/
	s/^simViewName.*/simViewName = \"$(echo ${VIEW_NAME})\"/
	s/^simCellName.*/simCellName = \"$(echo ${i})\"/
	s/^hnlNetlistFileName.*/hnlNetlistFileName = \"$(echo ${i}).sp\"/
	" ./"${i}"/si.env &)

	#Debugging sed
	# echo sed -i "
	# s/^simLibName.*/simLibName = \"$(echo ${CELL_LIBRARY})\"/
	# s/^simViewName.*/simViewName = \"$(echo ${VIEW_NAME})\"/
	# s/^simCellName.*/simCellName = \"$(echo ${i})\"/
	# s/^hnlNetlistFileName.*/hnlNetlistFileName = \"$(echo ${i}).sp\"/
	# " ./"${i}"/si.env

done
