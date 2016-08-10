#!/bin/bash -e

if [ "$#" -eq 3 ]; then
	CELL_LIBRARY="${1}"
	CELL_NAME="${2}"
	VIEW_NAME="${3}"

else
	echo "Usage: ./setupRunFile.sh <CELL_LIBRARY> <CELL_NAME> <VIEW_NAME>"
	exit 0
fi

#Get Current Directory Snippet
#http://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#Change the settings here
CELL_LIBRARY="${CELL_LIBRARY:-CORELIB_LP_LVT}"
CELL_NAME="${CELL_NAME:-INV}"
VIEW_NAME="${VIEW_NAME:-cmos_sch}"
TEMPLATE_DIR="${DIR}/netlistTemplate"

#Setup Directories
CELL_DIR="${DIR}/${CELL_LIBRARY}/${CELL_NAME}"

mkdir -p "${DIR}/${CELL_LIBRARY}/"
rsync -ar --inplace "${TEMPLATE_DIR}/" "${CELL_DIR}"



#Replace the following properties
#simLibName = "${CELL_LIBRARY}"
#simViewName = "${VIEW_NAME}"
#simCellName = "${i}"
#hnlNetlistFileName = "${i}.sp"
echo "Setting up run directory for ${CELL_LIBRARY}/${CELL_NAME}/${VIEW_NAME}"

#Using varibles in sed
#http://unix.stackexchange.com/questions/148967/how-to-use-a-shell-variable-inside-seds-s-command
(sed -i "
s/^simLibName.*/simLibName = \"$(echo ${CELL_LIBRARY})\"/
s/^simViewName.*/simViewName = \"$(echo ${VIEW_NAME})\"/
s/^simCellName.*/simCellName = \"$(echo ${CELL_NAME})\"/
s/^hnlNetlistFileName.*/hnlNetlistFileName = \"$(echo ${CELL_NAME}).sp\"/
" "${CELL_DIR}"/si.env &)

#Debugging sed
# echo sed -i "
# s/^simLibName.*/simLibName = \"$(echo ${CELL_LIBRARY})\"/
# s/^simViewName.*/simViewName = \"$(echo ${VIEW_NAME})\"/
# s/^simCellName.*/simCellName = \"$(echo ${i})\"/
# s/^hnlNetlistFileName.*/hnlNetlistFileName = \"$(echo ${i}).sp\"/
# " ./"${i}"/si.env

echo "Netlisting ${CELL_NAME}"

(cd "${CELL_DIR}"; ./runNetlist.sh | tee ./netlist.log &)
