This repository contains various Dockerfiles and shell scripts for containerising Matters's services. **All files are under heavily devewlopment**, so we have not implemented any further optimization.

## Overview ##

Here is the project structure:

```
matters-docker
│
├── README.md
│
├── docker
│   ├── base
│   │   └── Dockerfile
│   └── server
│       ├── dev
│       │   └── Dockerfile
│       └── prod
│           └── Dockerfile
│
└── shell
    ├── build-base.sh
    ├── build-server-dev.sh
    ├── start-server-dev.sh
    └── util.sh

```

#### Docker ####
In `docker` folder, you should be able to find all Dockerfiles. Currently, the base image is `Ubuntu 16.04`. But there is no strong need to build every Docker image on top of Ubuntu. For exmaple, `IPFS` has it own official Docker image, and we should just fork it.

#### Shell ####
In `shell` folder, there are some useful scripts for building or starting docker. In the future, we wish to provide a command line tool that packs all scripts.

## How to build ##
To build Docker image, you can run:

```
docker build --no-cache -t [image-name-and-tag] [path-to-dockerfile]
```

Or, run the script like this:

```
sh shell/build-base.sh
```

## How to run ##
To run Docker container, you can execute:

```
docker run -d -p [port:port] -e [env-var] [docker-image-name]
```

Or, run the script like this:

```
sh shell/start-server-dev.sh
```
