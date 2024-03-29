# IPFS Cluster with Docker Compose

## Setup

### Setup EC2 instances

- create at least 2 ubuntu EC2 instances
- `sudo apt install python-minimal` on the instances

### Setup Ansible

- `$ pip3 install --user ansible`
- `$ ansible-galaxy install christiangda.amazon_cloudwatch_agent`
- copy `hosts.example` to `hosts`, and update hosts information according to the instances
- copy `.env.example` to `.env`, replace `CLUSTER_SECRET` with the output from the following commend:
  - `od -vN 32 -An -tx1 /dev/urandom | tr -d ' \n'; echo`
- run `ansible-playbook -u ubuntu -i hosts playbook.yml` to install docker and upload files to EC2 instances

## Upgrade IPFS version

- SSH into the IPFS node server
- change the line in docker-compose file: `image: ipfs/go-ipfs:v0.14.0`
- `docker-compose pull`
- `docker-compose down`
- `docker-compose up -d`

## Launch IPFS Cluster

- `ssh` to all master (leader) and worker nodes:
  - `cd ~/ipfs`
  - `docker-compose up` (in order to populate `service.json` on each node)
- on master node:
  - copy the line `/ip4/127.0.0.1/tcp/9096/ipfs/<LEADER_NODE_HASH>`
  - replace the IP of above to `/ip4/<LEADER_NODE_IP>/tcp/9096/ipfs/<LEADER_NODE_HASH>`
  - `docker-compose down`
  - `docker-compose up -d` (`-d` for `daemon` mode)
- on worker nodes:
  - `cd ~/ipfs`
  - `docker-compose down`
  - `docker-compose run cluster daemon --bootstrap /ip4/<LEADER_NODE_IP>/tcp/9096/ipfs/<LEADER_NODE_HASH>`
  - ignore the warnings about port 5001 refused
  - once you see the cluster peers in the output, ctrl-c to quit
  - `docker-compose up` again; (run `docker-compose up -d` in `daemon` mode)

## Verify the Cluster

- `ssh` to any of the above nodes
- `cd ~/ipfs`
- `docker-compose exec cluster sh`
- `ipfs-cluster-ctl peers ls` to check output of node members
- use `ipfs-cluster-ctl pin ls` to list all objects

## Caveats

- when run IPFS in cluster mode, the HTTP API port should be changed from `5001` to `9095`
- need to use `ipfs-cluster-ctl pin add` or `curl <IP>:9095/api/v0/add/pin` to move exists objects to cluster pinset
- Once setup, on the gateway node, do `ipfs bootstrap add /ip4/13.228.12.125/tcp/4001/ipfs/Qmeg7J9S2EsXwPKLrSz5QeirGLmToWDHhj6EPmUvquKb5k`
