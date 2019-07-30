#!/bin/bash

set -e

if [ ! "$EUID" -ne 0 ]
  then echo "Please don't run as root"
  exit
fi

BASEDIR=$(dirname "$0")
cd $BASEDIR/../

sudo ifconfig eth0 down && sudo ifconfig eth0 up
sudo ifconfig docker0 down && sudo ifconfig docker0 up 

docker-compose -f docker-compose.yml -f docker-compose-wsl.yml up -d

DNSMASQ_IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' consul_dnsmasq`

echo "
nameserver ${DNSMASQ_IP}
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
" > ./resolv.conf

sudo mv -f ./resolv.conf /etc/resolv.conf
