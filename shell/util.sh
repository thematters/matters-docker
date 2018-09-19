#!/bin/bash
#
# This script is a collection of useful functions.
#

CC='\033[01;36m'
WC='\033[01;37m'
NC='\033[0m'

coloredEcho()
{
    COLOR=$NC

    case $1 in
        'cyan')
            COLOR=$CC
            ;;
        'white')
            COLOR=$WC
            ;;
    esac

    echo ""
    echo "$COLOR$2$NC"
}
