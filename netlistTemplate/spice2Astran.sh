#/bin/bash -e

#Calls sed to replace the Cadence extracted spice netlist to be compatible with ASTRAN netlist

#Replace '.PARAM' to '*.PARAM'
#Replace 'VDD!' to 'VCC'
#Replace 'VSS!' to 'GND'
#Replace all pmos transistor instances to 'PMOS'
#Replace all nmos transistor instances to 'NMOS'
#Separate out the Width and Length paramaters from ther other parameters
PMOS_TRANSISTOR="pmos_1p5_lvt"
NMOS_TRANSISTOR="nmos_1p5_lvt"
VDD_NAME="VDD!"
GND_NAME="VSS!"

#Normal sed command
# sed "
# s/^\.PARAM/\*&/g
# s/$(echo $VDD_NAME)/VCC/g
# s/$(echo $GND_NAME)/GND/g
# s/$(echo $PMOS_TRANSISTOR)/PMOS/g
# s/$(echo $NMOS_TRANSISTOR)/NMOS/g
# /^\.SUBCKT/,/\.ENDS/s/L=[^ ]* /&\n\+ /
# " "$@"

#Enable this if netlisting the inherited CORELIB_LP_LVT
sed "
s/^\.PARAM/\*&/g
s/$(echo $VDD_NAME)/VCC/g
s/$(echo $GND_NAME)/GND/g
s/$(echo $PMOS_TRANSISTOR)/PMOS/g
s/$(echo $NMOS_TRANSISTOR)/NMOS/g
/^\.SUBCKT/,/\.ENDS/s/L=[^ ]* /&\n\+ /
s/^\.SUBCKT.*/& VCC GND/
" "$@"
