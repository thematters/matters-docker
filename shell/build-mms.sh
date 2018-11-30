#!/bin/bash
#
# This script is for building image (matters-mms:stage).
#

SHELL_PATH="$(cd "$(dirname "$0")"; pwd -P)"

PARENT_PATH="$(dirname $SHELL_PATH)"

source $SHELL_PATH/util.sh

coloredEcho cyan "Building migration image"

docker build --no-cache -t matters-mms:stage $PARENT_PATH/docker/mms
