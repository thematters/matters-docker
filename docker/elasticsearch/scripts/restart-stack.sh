#!/usr/bin/env bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
BASEDIR=$(dirname "$0")
cd $BASEDIR/..

pwd

docker stack rm es
sleep 30s
docker stack deploy -c docker-compose.yml es
