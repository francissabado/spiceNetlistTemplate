#!/bin/bash

if [ "$#" -eq 5 ];
then

	PMOS_WIDTH_IZ="${1}"
	NMOS_WIDTH_IZ="${2}"
	PMOS_INV="${3}"
	NMOS_INV="${4}"
	NETLIST="${5}"
	
	echo "Currently broken. Dont use. Use other option."
	
elif [ "$#" -eq 6 ];
then
	PMOS_WIDTH_IZ="${1}"
	NMOS_WIDTH_IZ="${2}"
	PMOS_INV="${3}"
	NMOS_INV="${4}"
	CELLNAME="${5}"
	NETLIST="${6}"

elif [ "$#" -eq 8 ];
then
	PMOS_WIDTH_IZ="${1}"
	NMOS_WIDTH_IZ="${2}"
	PMOS_INV="${3}"
	NMOS_INV="${4}"
	SLEEPPULLUP="${5}"
	SLEEPPULLDOWN="${6}"
	CELLNAME="${7}"
	NETLIST="${8}"
	
else

echo "Usage: ./setCellParam.sh <pmosWidthIZ> <nmosWidthIZ> <pmosInv> <nmosInv> <NETLIST>
Format in nanometer: 300n 300n 160n 160n ./netlist.sp
Format in micron: .3u .3u .16u .16u ./netlist.sp

With CELLNAME:
Usage: ./setCellParam.sh <pmosWidthIZ> <nmosWidthIZ> <pmosInv> <nmosInv> <CELLNAME> <NETLIST>
" 

exit 0

fi

filename=$(basename "$NETLIST")
NETLIST_EXT="${filename##*.}"
NETLIST_NAME="${filename%.*}"

#Default For HOLD transistors
PMOS_HOLD=300n
NMOS_HOLD=300n



# More info on grouping. Don't scape '\(' and '\)' use for grouping
# http://unix.stackexchange.com/questions/64195/how-to-replace-a-left-parenthesis-with-sed

# Change parameters
sed "
s/(pmosWidthIZ)/$(echo $PMOS_WIDTH_IZ)/g
s/(nmosWidthIZ)/$(echo $NMOS_WIDTH_IZ)/g
s/(pmosInv)/$(echo $PMOS_INV)/g
s/(nmosInv)/$(echo $NMOS_INV)/g
s/(pmoswidthIZ)/$(echo $PMOS_WIDTH_IZ)/g
s/(nmoswidthIZ)/$(echo $NMOS_WIDTH_IZ)/g
s/(pmoswidthInv)/$(echo $PMOS_INV)/g
s/(nmoswidthInv)/$(echo $NMOS_INV)/g
s/(pmosWidthInv)/$(echo $PMOS_INV)/g
s/(nmosWidthInv)/$(echo $NMOS_INV)/g
s/(PmosHold)/$(echo $PMOS_HOLD)/g
s/(NmosHold)/$(echo $NMOS_HOLD)/g
s/(pmosHold)/$(echo $PMOS_HOLD)/g
s/(nmosHold)/$(echo $NMOS_HOLD)/g
s/(HOLD1)/$(echo $PMOS_HOLD)/g
s/(HOLD0)/$(echo $NMOS_HOLD)/g
s/(sleepPullUp)/$(echo $SLEEPPULLUP)/g
s/(sleepPullDown)/$(echo $SLEEPPULLDOWN)/g
" "${NETLIST}" > ${CELLNAME}.sp

#Set subcircuit name
if [ ! -z "${CELLNAME}" ]; then
	sed -i "
	s/\(\.SUBCKT \)[A-Za-z0-9_]*/\1$(echo $CELLNAME)/g
	" ${CELLNAME}.sp
fi

# Create Astran
bash ./spice2Astran.sh ${CELLNAME}.sp > $(echo $CELLNAME | tr [a-z] [A-Z] )_ASTRAN.sp

sed "
s/ W=/ totalW=/g
" ${CELLNAME}.sp > ${CELLNAME}_IMP.sp



