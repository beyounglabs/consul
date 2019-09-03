#!/bin/bash

set -e

if [ ! "$EUID" -ne 0 ]
  then echo "Please don't run as root"
  exit
fi

BASEDIR=$(dirname "$0")
cd $BASEDIR

chmod +x dnsmasq/entrypoint.sh
chmod +x nginx/entrypoint.sh

# Create Network Consul
[[ $(docker network ls | grep consul) ]] || docker network create consul
docker-compose up -d

DNSMASQ_IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' consul_dnsmasq`

echo "
nameserver ${DNSMASQ_IP}
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
" > ./resolv.conf

sudo mv -f ./resolv.conf /etc/resolv.conf
