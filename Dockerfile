FROM ubuntu:20.04

RUN apt update -y && apt install munge -y && apt install vim -y && apt install build-essential -y && apt install git -y && apt-get install mariadb-server -y && apt install wget -y

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurm-client -y
RUN apt install curl dirmngr apt-transport-https lsb-release ca-certificates -y
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install sudo -y && apt install python3.9 python3-pip -y && useradd -m admin -s /usr/bin/bash -d /home/admin && echo "admin:admin" | chpasswd && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt update -y && apt install nodejs -y && npm install -g configurable-http-proxy && pip3 install jupyterlab==2.1.2 

COPY slurm.conf /etc/slurm-llnl/
COPY cgroup.conf /etc/slurm-llnl/
COPY docker-entrypoint.sh /etc/slurm-llnl/

COPY munge.key /etc/munge/
RUN chmod 400 /etc/munge/munge.key
RUN chown munge:munge /etc/munge/munge.key

WORKDIR /home/admin
EXPOSE 8888

ENV USER admin
ENV SHELL bash

RUN apt install libopenmpi-dev -y && pip3 install mpi4py && pip3 install jupyterlab_slurm && pip3 install nbgitpuller

ENTRYPOINT [ "/etc/slurm-llnl/docker-entrypoint.sh"]
