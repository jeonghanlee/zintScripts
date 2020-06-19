#!/usr/bin/env bash
#
#  Copyright (c) 2020  Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Friday, June 19 15:00:49 PDT 2020
# version : 0.0.1
#

declare -gr SC_SCRIPT="$(realpath "$0")";
declare -gr SC_SCRIPTNAME=${0##*/};
declare -gr SC_TOP="${SC_SCRIPT%/*}";
declare -g  SC_VERSION="0.0.1";
declare -g  STARTUP="";


function pushd { builtin pushd "$@" > /dev/null; }
function popd  { builtin popd  "$@" > /dev/null; }

declare -a qrid_list=();
declare -g CDB_URL="";


declare -gr ex_input_name="qr_id_list";

function usage
{
    {
	echo "";
	echo "Usage    : $0 [-l ${ex_input_name}] "
	echo "";
	echo "               -l : ${ex_input_name} "
	echo "";
	echo " echo \"CDB_URL=https://localhost/aaa/bbb\" > cdrurl.local"

	echo "";
	echo " bash $0 -l ${ex_input_name}"
	echo ""
	
    } 1>&2;
    exit 1; 
}




function qrid_from_list
{
    local i=0;
    local j=0;
    local pv;
    local filename="$1"
    local raw_list=();
    local temp_list=();
    let i=0
    while IFS= read -r line_data; do
	if [ "$line_data" ]; then
	    [[ "$line_data" =~ ^#.*$ ]] && continue
	    raw_list[i]="${line_data}"
	    ((++i))
	fi
    done < "${filename}"

    # https://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash
    IFS=$'\n' read -d '' -r -a temp_list < <(printf '%s\n' "${raw_list[@]}" | sort)

    let i=0;
    for qrid in ${temp_list[@]}; do
	qrid_list[i]="$qrid"
	((++i))
    done
}



function generateQRCodes_from_list
{
    local url_base="${CDB_URL}/views/itemDomainInventory/view?qrId=";
    local qr_id="";
    local output_prefix="alsu_cdb_";
    local output_suffix=".png";
    local sleep_interval=0.001;
    local i=0;
    
    printf ">> Generate QR codes ....\n"
    let i=0
    for qr_id in ${qrid_list[@]}; do
	printf " $i  ... ${output_prefix}${qr_id}${output_suffix} \n"
	echo "zint -o ${output_prefix}${qr_id}${output_suffix} --border=4  -b 58  -d "${url_base}${qr_id}""
	zint -o ${output_prefix}${qr_id}${output_suffix} --border=4  -b 58  -d "${url_base}${qr_id}"
	sleep ${sleep_interval}
    done
    printf "\n";
}





options="l:"
LIST=""


while getopts "${options}" opt; do
    case "${opt}" in
        l) LIST=${OPTARG}      ;;
   	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    usage
	    ;;
	h)
    usage
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    usage
	    ;;
    esac
done
shift $((OPTIND-1))



if [ -z "$LIST" ]; then
    usage;
fi

set -a
if [ -r ${SC_TOP}/cdburl.local ]; then
    printf ">>> We've found the local configuration file.\n";
    . ${SC_TOP}/cdburl.local
    printf " CDB_URL = %s\n\n" "${CDB_URL}"

else
    usage;
fi
set +a


qrid_from_list "${LIST}" 

generateQRCodes_from_list

