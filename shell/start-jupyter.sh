#!/bin/bash
#
# This script is for running jupyter container for analytics.
#

RC='\033[01;31m'
CC='\033[01;36m'
WC='\033[01;37m'
NC='\033[0m'

SHELL_PATH="$(cd "$(dirname "$0")"; pwd -P)"

PARENT_PATH="$(dirname $(dirname $SHELL_PATH))"

source $SHELL_PATH/util.sh

MOUNT_VOLUME=$1
SPACES='   '

if [ -z $1 ]; then
    coloredEcho white "${RC}1.${NC} Specify a path for monuting (e.g. ${CC}${PARENT_PATH}/matters-analytics/notebooks${NC})"
    read -p "${SPACES}Path: " MOUNT_VOLUME
else
    coloredEcho white "${RC}1${NC}. You've specified path as mountuing volume: ${MOUNT_VOLUME}"
fi

coloredEcho white "${RC}2.${NC} Enter your AWS Access key id"
read -p "${SPACES}Access key: " ID

coloredEcho white "${RC}3.${NC} Enter your AWS Secret key"
read -p "${SPACES}Secret key: " KEY

echo ""
echo "${RC}4.${NC} Running your container ..."

# TODO: Ask to remove or not
docker rm -f jupyter >/dev/null 2>&1

docker run -d                                                                   \
           -p 8888:8888                                                         \
           -v $MOUNT_VOLUME:/home/jovyan/work                                   \
           -e AWS_ACCESS_KEY_ID="$ID"                                           \
           -e AWS_SECRET_ACCESS_KEY="$KEY"                                      \
           --name jupyter                                                       \
           matterslab/analytics                                                 \
           >/dev/null 2>&1

sleep 4

echo ""
echo $(docker logs jupyter)

coloredEcho white "${RC}5.${NC} To restart the jupyter: ${CC}docker restart jupyter${NC}"

coloredEcho white "${RC}6.${NC} To stop the jupyter: ${CC}docker stop jupyter${NC} 🦊"
echo ""
