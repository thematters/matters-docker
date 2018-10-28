#!/bin/bash
#
# This script is for building image (matters-dynamo:dev).
#

SHELL_PATH="$(cd "$(dirname "$0")"; pwd -P)"

PARENT_PATH="$(dirname $SHELL_PATH)"

source $SHELL_PATH/util.sh

coloredEcho cyan "Building Dynamo image for development environment"

docker build --no-cache -t matters-dynamo:dev $PARENT_PATH/docker/dynamo
