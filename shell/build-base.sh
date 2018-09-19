#!/bin/bash
#
# This script is for building image (matters:base).
#

SHELL_PATH="$(cd "$(dirname "$0")"; pwd -P)"

PARENT_PATH="$(dirname $SHELL_PATH)"

source $SHELL_PATH/util.sh

coloredEcho cyan "Building base image"

docker build --no-cache -t matters:base $PARENT_PATH/docker/base
