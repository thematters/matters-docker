#!/bin/bash
#
# This script is for building image (matters-server:dev).
#

SHELL_PATH="$(cd "$(dirname "$0")"; pwd -P)"

PARENT_PATH="$(dirname $SHELL_PATH)"

source $SHELL_PATH/util.sh

coloredEcho cyan "Building server image for development environment"

docker build --no-cache -t matters-server:dev $PARENT_PATH/docker/server/dev
