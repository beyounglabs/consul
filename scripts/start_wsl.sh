#!/bin/bash

set -e

if [ ! "$EUID" -ne 0 ]
  then echo "Please don't run as root"
  exit
fi

BASEDIR=$(dirname "$0")
cd $BASEDIR/../

# Create Network Consul
[[ $(docker network ls | grep consul) ]] || docker network create consul

ETH0_IP=`ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
echo "ETH0_IP=${ETH0_IP}" > .env

docker-compose -f docker-compose.yml -f docker-compose-wsl.yml up -d

DNSMASQ_IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' consul_dnsmasq`

echo "
nameserver ${DNSMASQ_IP}
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
" > ./resolv.conf

sudo mv -f ./resolv.conf /etc/resolv.conf

MAX_USER_WATCHES=524288
sudo sed -ri 's/^(fs\.inotify\.max_user_watches\=)(.*)$/\1'"$MAX_USER_WATCHES"'/g' /etc/sysctl.conf
sudo sysctl -p >> /dev/null

# etc/hosts
cp -f /mnt/c/Windows/System32/drivers/etc/hosts ./hosts
HOSTS_TO_CHANGE=`cat ./hosts | grep -e .develop -e.service.consul`
echo $HOSTS_TO_CHANGE | awk -v ip="$ETH0_IP" '{split($0, a, " "); system("sed -ri \"s/" a[1] "/" ip "/g\" ./hosts")}' 
sudo cp -f ./hosts /mnt/c/Users/$USER/Desktop/hosts 

# sudo ifconfig eth0 down && sudo ifconfig eth0 up
# sudo ifconfig docker0 down && sudo ifconfig docker0 up 