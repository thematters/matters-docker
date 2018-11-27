#!/bin/bash
#
# This script is for running Postgres up in dev environment.
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

coloredEcho white 'Run Postgres up for dev environment'
docker run -d                                                                \
           -v $MOUNT_VOLUME/:/var/lib/postgresql/data                        \
           -p 5432:5432                                                      \
           -e POSTGRES_DB=matters-dev                                        \
           -e POSTGRES_USER=matters-dev                                      \
           -e POSTGRES_PASSWORD=matters-dev                                  \
           --name postgres                                                   \
           postgres:latest
