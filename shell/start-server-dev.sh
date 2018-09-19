#!/bin/bash
#
# This script is for running server up in dev environment.
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

coloredEcho white 'Run server up for dev environment'
docker run -d                                                                \
           -p 8888:8888                                                      \
           -e MATERIA_LOCALDEV=true                                          \
           -e MATERIA_DB_HOST=docker.for.mac.localhost                       \
           -e MATERIA_DB_PORT='27017'                                        \
           -e MATERIA_DB_DATABASE='matters-dev'                              \
           -e MATERIA_DOMAIN='http://localhost:8888'                         \
           -e MATERIA_SENDGRID_KEY=''                                        \
           -v $MOUNT_VOLUME/:/home/ubuntu/materia                            \
           --hostname server                                                 \
           --name server                                                     \
           matters-server:dev
