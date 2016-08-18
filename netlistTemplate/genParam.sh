#!/bin/env bash


if [ "$#" -ne 2 ]; then

echo "
Usage: ./genParam.sh <NETLISTFILE> <OUTPUTLIB>
"
	exit 1

fi


sed "
s#<NETLISTFILE>#$(echo $1)#g
s#<OUTPUTLIB>#$(echo $2)#g
" ./spiceInTemp.params
