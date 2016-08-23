#!/bin/bash -e

#Change the settings here
CELL_LIBRARY="charteredNCL_sized"
VIEW_NAME="schematic"
TEMPLATE_DIR="netlistTemplate"
CELL_NAME="${i}"


declare -a cellList=(
	"th23w2_XL"
	"th23w2_X1"
	"th23w2_X2"
	"th23w2_X4"
	"th23w2_X6"
	"th23w2_X8"
	"th24_XL"
	"th24_X1"
	"th24_X2"
	"th24_X4"
	"th24_X6"
	"th24_X8"
	
)

#Read new line separated list.
#Read file into an array. Must be separted by newlines.
# readarray -t cellList < CORELIB_LP_LVT.list

#Print cellList new line separated
printf '%s\n' "${cellList[@]}" > cellList.list

cellCount=${#cellList[@]}

printf "Netlisting %d\n" "${cellCount}"

for i in "${cellList[@]}";
do



	(./setupRunFile.sh "${CELL_LIBRARY}" "${i}" "${VIEW_NAME}")
	#
	#
	# #Copy templates
	# rsync -ar --inplace ./"${TEMPLATE_DIR}"/ ./"${i}"
	# # -r : recursive
	#
	# #Replace the following properties
	# #simLibName = "${CELL_LIBRARY}"
	# #simViewName = "${VIEW_NAME}"
	# #simCellName = "${i}"
	# #hnlNetlistFileName = "${i}.sp"
	# echo "Setting up run directory for ${i}"
	#
	# #Using varibles in sed
	# #http://unix.stackexchange.com/questions/148967/how-to-use-a-shell-variable-inside-seds-s-command
	# (sed -i "
	# s/^simLibName.*/simLibName = \"$(echo ${CELL_LIBRARY})\"/
	# s/^simViewName.*/simViewName = \"$(echo ${VIEW_NAME})\"/
	# s/^simCellName.*/simCellName = \"$(echo ${i})\"/
	# s/^hnlNetlistFileName.*/hnlNetlistFileName = \"$(echo ${i}).sp\"/
	# " ./"${i}"/si.env &)

	#Debugging sed
	# echo sed -i "
	# s/^simLibName.*/simLibName = \"$(echo ${CELL_LIBRARY})\"/
	# s/^simViewName.*/simViewName = \"$(echo ${VIEW_NAME})\"/
	# s/^simCellName.*/simCellName = \"$(echo ${i})\"/
	# s/^hnlNetlistFileName.*/hnlNetlistFileName = \"$(echo ${i}).sp\"/
	# " ./"${i}"/si.env

done
