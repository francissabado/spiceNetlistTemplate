#!/bin/bash

# -e

if [ "$#" -eq 1 ] ; then
    SPICE_NETLIST="${1}"

else
    echo "Usage: ./spice2Astran.sh <netlist>"
    exit 0
fi

#Calls sed to replace the Cadence extracted spice netlist to be compatible with ASTRAN netlist

#Replace '.PARAM' to '*.PARAM'
#Replace 'VDD!' to 'VCC'
#Replace 'VSS!' to 'GND'
#Replace all pmos transistor instances to 'PMOS'
#Replace all nmos transistor instances to 'NMOS'
#Separate out the Width and Length paramaters from ther other parameters
PMOS_TRANSISTOR="pmos_1p5"
NMOS_TRANSISTOR="nmos_1p5"
PMOS_TRANSISTOR_LVT="pmos_1p5_lvt"
NMOS_TRANSISTOR_LVT="nmos_1p5_lvt"
VDD_NAME="VDD!"
GND_NAME="VSS!"

# Normal sed command
sed "
s/^\.PARAM/\*&/g
s/$(echo $VDD_NAME)/VCC/g
s/$(echo $GND_NAME)/GND/g
s/$(echo $PMOS_TRANSISTOR_LVT)/PMOS/g
s/$(echo $NMOS_TRANSISTOR_LVT)/NMOS/g
s/$(echo $PMOS_TRANSISTOR)/PMOS/g
s/$(echo $NMOS_TRANSISTOR)/NMOS/g
/^\.SUBCKT/,/\.ENDS/s/L=[^ ]* /&\n\+ /
s/\(W=[0-9].*\)e-9/\1n/g
s/\(W=[0-9].*\)e-8/\10n/g
s/\(W=[0-9].*\)e-7/\100n/g
s/\(W=[0-9].*\)e-6/\1u/g
s/\(L=1.3e-07\)/L=130n/g
" "${SPICE_NETLIST}"

#Enable this if netlisting the inherited CORELIB_LP_LVT
# sed "
# s/^\.PARAM/\*&/g
# s/$(echo $VDD_NAME)/VCC/g
# s/$(echo $GND_NAME)/GND/g
# s/$(echo $PMOS_TRANSISTOR)/PMOS/g
# s/$(echo $NMOS_TRANSISTOR)/NMOS/g
# /^\.SUBCKT/,/\.ENDS/s/L=[^ ]* /&\n\+ /
# s/^\.SUBCKT.*/& VCC GND/
# " "$@"
