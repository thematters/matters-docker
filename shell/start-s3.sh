#!/bin/bash
#
# This script is for running S3 up in dev environment.
#

CC='\033[01;36m'
WC='\033[01;37m'
NC='\033[0m'

SHELL_PATH="$(cd "$(dirname "$0")"; pwd -P)"

PARENT_PATH="$(dirname $SHELL_PATH)"

source $SHELL_PATH/util.sh

coloredEcho white 'Run S3 up for dev environment'
docker run -d                                                                \
           -p 4569:4569                                                      \
           --name s3                                                         \
           lphoward/fake-s3
