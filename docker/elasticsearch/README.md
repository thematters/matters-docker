# Setup guide

## Setup docker swarm on local environment

* make sure you have `docker` and `virtualbox` installed
* create 3 docker machines to run the swarm nodes:
  * `docker-machine create -d virtualbox master`
  * `docker-machine create -d virtualbox worker1`
  * `docker-machine create -d virtualbox worker2`
* init docker swarm manager:
  * `eval $(docker-machine env master)`
  * `docker swarm init --advertise-addr=$(docker-machine ip master)`
  * copy the `docker swarm join --token SOME_TOKEN_STRING` command from the output for later usage
* join the workers to the swarm:
  * `eval $(docker-machine env worker1)`
  * paste the command you copied from eariler
  * repeat the above two steps for worker2
* list the existing swarm nodes:
  * using the manager node: `eval $(docker-machine env master)`
  * `docker node ls` 