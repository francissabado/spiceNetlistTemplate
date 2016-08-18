#!/bin/bash

#This assumes that all libraries will be imported in
if [ "$#" -eq 1 ]; then
	OUTPUTLIB="$1"
else

echo "
Usage: ./spiceIn.sh <OUTPUTLIB>
"
exit 1

fi

#Assumes that this is run on the current directory
CADENCE_SCRIPT=$HOME/Tezzaron3D_project/tezz3D-runscript2
CADENCE_HOME=$HOME/Tezzaron3D_project/tezzaron_circuits_fsabado
#OUTPUTLIB="charteredNCL_IMP"


if [ ! -e "./cds.lib" ]; then
	ln -s "${CADENCE_HOME}/cds.lib" .
fi

# Check if TDP_DIR is unset
if [ -z ${TDP_DIR+x} ];then
	source $CADENCE_SCRIPT
fi

if [ $(find . -name "*_IMP.sp" | wc -l) -eq 0 ]; then
	echo "No import file netlist"
	exit 1
fi


for netlistFile in ./*_IMP.sp ; do
	./genParam.sh $netlistFile $OUTPUTLIB > ${netlistFile}.params
	echo "Generated ${netlistFile}.params"
done


for netlistParam in ./*sp.params ; do
	spiceIn -param $netlistParam
done

#spiceIn -param $1




