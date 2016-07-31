#!/bin/bash -e
#This run the Simulation Environment and generate a netlist

#Settings
NETLIST_CDSLIB="${HOME}/Tezzaron3D_project/tezzaron_circuits_fsabado/cds.lib"
PROJECT_DIR="${HOME}/Tezzaron3D_project"
PROJECT_ENVIRONMENT_SCRIPT="${HOME}/Tezzaron3D_project/tezz3D-runscript2"


#Get Current Directory Snippet
#http://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#http://stackoverflow.com/questions/29324463/source-from-string-is-there-any-way-in-shell
echo "Loading Environment"
source ~/Tezzaron3D_project/tezz3D-runscript2 >/dev/null 2>&1

si -batch -command netlist -cdslib "${NETLIST_CDSLIB}" "${DIR}"
echo "Done"
