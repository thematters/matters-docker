# Setup guide

## Setup docker swarm on local environment

* make sure you `Ansible`, `Vagrant` and `Virtualbox` installed
* create 2 virtual machines to run the swarm nodes:
  * `vagrant up`, then wait for the 2 nodes to be ready
  * `vagrant ssh-config >> ~/.ssh/config
  * try `ssh master` and `ssh worker` to check if you can successfully ssh into the nodes
  * install pythons on the nodes with `sudo apt install python-minimal`
  * set `vm.max_map_count` to `262144` on the nodes:
    * `sudo sysctl -w vm.max_map_count=262144`
    * append `vm.max_map_count=262144` at the end of `/etc/sysctl.conf`
  * install docker on the nodes with `ansible-playbook -i hosts.example playbook.yml` 
* init docker swarm manager:
  * `ssh master`
  * `docker swarm init --advertise-addr=192.168.50.10`
  * copy the `docker swarm join --token SOME_TOKEN_STRING` command from the output for later usage
* join the workers to the swarm:
  * `ssh worker`
  * paste the command you copied from eariler
* list the existing swarm nodes:
  * `ssh master`
  * `docker node ls` 

## Start ElasticSearch cluster on local environment

* `ssh master`
* `cd ~/elasticsearch`
* `docker stack deploy -c docker-compose.yml es`
* `curl http://192.168.50.10:9200/_cluster/state?pretty` to check cluster status

## Deploy ElasticSearch cluster on EC2 instances

* create EC2 instances as elasticsearch nodes
* add the following inbound roles to EC2 security group
  * Custom TCP Rule	TCP	 2377  swarm + remote mgmt
  * Custom TCP Rule	TCP	 7946	 swarm
  * Custom UDP Rule	UDP	 7946	 swarm
  * Custom UDP Rule	UDP	 4789	 swarm
  * Custom Protocol	50	 all	 swarm
* connect to VPN so that you can communicate with the EC2 instances on your local machine
* `cp hosts.example hosts`
* update `hosts` so that ansible can deploy ElasticSearch cluster to correct EC2 instances
* install docker on the nodes with `ansible-playbook -i hosts playbook.yml` 
* init docker swarm manager:
  * ssh EC2 master node
  * `docker swarm init --advertise-addr={{PRIVATE_IP}}`
  * copy the `docker swarm join --token SOME_TOKEN_STRING` command from the output for later usage
* join the workers to the swarm:
  * ssh EC2 worker node
  * paste the command you copied from eariler
* list the existing swarm nodes:
  * `ssh master`
  * `docker node ls` 

## Start ElasticSearch cluster on EC2 instances

* ssh EC2 master node
* `cd ~/elasticsearch`
* `docker stack deploy -c docker-compose.yml es`
* `curl http://{{PRIVATE_IP}}:9200/_cluster/state?pretty` to check cluster status
