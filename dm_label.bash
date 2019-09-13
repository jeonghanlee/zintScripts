#!/bin/bash
#
#  Copyright (c) 2019  Jeong Han Lee
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
# Date    : Thursday, September 12 03:42:38 CDT 2019 
# version : 0.0.1
#

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"


. ${SC_TOP}/.functions


function usage
{
    {
	echo "";
	echo "Usage    : $0 options";
	echo "";
	echo "              possbile options";
	echo "";
	echo "              [-d <data>]     [-d <print_label>]";
	echo "";
	echo "               -d : default demo 123"
	echo "Usage    : $0 data ";
	echo "";
	echo "";
	echo " bash $0 -d 123456789 -p"
	echo ""
	
    } 1>&2;
    exit 1; 
}



options=":d:hp"
PRINT="NO"


while getopts "${options}" opt; do
    case "${opt}" in
        d) DATA=${OPTARG}          ;;
   	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    exit 1
	    ;;
	p) PRINT="YES" ;;
	h)
	    usage
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    exit
	    ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$DATA" ]; then
    usage;
    exit
fi


create_dmlabel_image "$DATA"
if [ "$PRINT" == "YES" ]; then
    lpr_dmlabel "$DATA"
fi


exit 0;
