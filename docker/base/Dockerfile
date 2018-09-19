# Base image with default user and useful packages.
#

FROM ubuntu:16.04

RUN apt-get update                                                                                              && \
    apt-get install -y autoconf build-essential curl figlet locales python rsync sudo vim libpng-dev psmisc     && \
    apt-get clean                                                                                               && \
    adduser --disabled-password --gecos '' --shell /bin/bash --home /home/ubuntu ubuntu                         && \
    usermod -aG sudo ubuntu                                                                                     && \
    echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers                                                       && \
    mkdir -p /var/www/html                                                                                      && \
    locale-gen en_US.UTF-8

ENV LANG   en_US.UTF-8
ENV LC_ALL en_US.UTF-8

USER ubuntu

WORKDIR /home/ubuntu

RUN echo 'export TERM=xterm' >> $HOME/.bashrc                                                                   && \
    echo 'export EDITOR=vim' >> $HOME/.bashrc
