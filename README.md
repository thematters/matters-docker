This repository contains various Dockerfiles and shell scripts for containerising services. **All files are under heavily development**, so we have not implemented any further optimization.

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
│   ├── mms
│   │   └── Dockerfile
│   └── server
│       ├── dev
│       │   └── Dockerfile
│       └── prod
│           └── Dockerfile
│
└── shell
    ├── build-base.sh
    ├── build-mms.sh
    ├── start-mms.sh
    ├── start-postgres.sh
    └── util.sh

```

#### Docker ####
In `docker` folder, you should be able to find all Dockerfiles. Currently, the base image is `Ubuntu 16.04`. But there is no strong need to build every Docker image on top of Ubuntu. For exmaple, `IPFS` has it own official Docker image, and we should just fork it.

Also, I don't think we need to create Dockerfile for Stage. Stage and Production should run on the same environment but only with different environment variables.

#### Shell ####
In `shell` folder, there are some useful scripts for building images or starting containers. In the future, we wish to provide a command line tool that packs all scripts. ：）

## Available images ##
Here is a list of images:

```
matters:base
matters-server:dev
matters-mms:stage
```

## How to build image ##
To build Docker image, you can run:

```
docker build --no-cache -t [image-name-and-tag] [path-to-dockerfile]
```

Or, run the script like this:

```
sh shell/build-base.sh
```

## How to run container up ##
To run Docker container, you can execute:

```
docker run -d -p [port:port] -e [env-var] [docker-image-name]
```

Or, run the script like this:

```
sh shell/start-postgres.sh
```

## Note ##
In the future, we might want to upload images to service like AWS ECR. So, the prefix of image name could be different.
