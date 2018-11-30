#!/bin/bash
#
# This script is for running migration container up for stage environment.
#

CC='\033[01;36m'
WC='\033[01;37m'
NC='\033[0m'

SHELL_PATH="$(cd "$(dirname "$0")"; pwd -P)"

PARENT_PATH="$(dirname $SHELL_PATH)"

source $SHELL_PATH/util.sh

MOUNT_VOLUME=$1

if [ -z $1 ]; then
    coloredEcho white "Specify a path for monuting volume (e.g. $CC$(pwd))$NC"
    read -p "Path: " MOUNT_VOLUME
else
    coloredEcho white "You've specified path as mountuing volume: $MOUNT_VOLUME"
fi

coloredEcho white 'Run migration container up for stage environment'
docker run -d                                                                           \
           -p 80:80                                                                     \
           -p 443:443                                                                   \
           -e MATTERS_ENV=stage                                                         \
           -e MATTERS_DB_HOST=''                                                        \
           -e MATTERS_DB_PORT='27017'                                                   \
           -e MATTERS_DB_USERNAME=''                                                    \
           -e MATTERS_DB_PASSWORD=''                                                    \
           -e MATTERS_DB_DATABASE=''                                                    \
           -e MATTERS_DYNAMODB_REGION=''                                                \
           -e MATTERS_DYNAMODB_ACCESS_ID=''                                             \
           -e MATTERS_DYNAMODB_ACCESS_KEY=''                                            \
           -v $MOUNT_VOLUME/:/home/ubuntu/matters-db-migration                          \
           --hostname migration                                                         \
           --name migration                                                             \
           matters-mms:stage
