# Setup guide

## Setup docker swarm on local environment

* Make sure you have `docker` and `virtualbox` installed
* Create 3 docker machines to run the swarm nodes:
  * `docker-machine create -d virtualbox master`
  * `docker-machine create -d virtualbox worker1`
  * `docker-machine create -d virtualbox worker2`
