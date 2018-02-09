#!/bin/bash

if [ ! "$EUID" -ne 0 ]
  then echo "Please don't run as root"
  exit
fi

# Create Network Consul
[[ $(docker network ls | grep consul) ]] || docker network create consul


# Clone Tuntap
[[ -d ./docker-tuntap-osx ]] || git clone git@github.com:AlmirKadric-Published/docker-tuntap-osx.git ./docker-tuntap-osx

# Update Tun Tap
cd ./docker-tuntap-osx
git pull origin master
cd ..


# Up Interface
# chown $USER /dev/tap1

# brew tap caskroom/cask
# brew cask reinstall tuntap

[[ $(ifconfig | grep tap1) ]] || sudo chown $USER /dev/tap1

POSSIBLE_PROCESS_NAMES=$(echo '
	com.docker.hyperkit
	hyperkit.original
')

processID=false
processName=false
for possibleName in $POSSIBLE_PROCESS_NAMES; do
	if pgrep -q $possibleName; then
		processID=$(pgrep $possibleName)
		processName=$possibleName
		break;
	fi
done

if [ "$processName" = false ]; then
	echo 'Could not find hyperkit process to kill, make sure docker is running' >&2
	exit 1;
fi

[[ $(ifconfig | grep tap1) ]] || echo "Restarting process '$processName' [$processID]"
[[ $(ifconfig | grep tap1) ]] || pkill "$processName"

count=0
while true; do
	sleep 2;

	dockerRunning=false

	[[ $(docker ps) ]] && dockerRunning=true

	if [ "$dockerRunning" != false ]; then
		break;
	fi

	count=$(($count + 1))
	if [ $count -gt 120 ]; then
		echo "Failed to start Docker"
		exit 1
	fi
done

./docker-tuntap-osx/sbin/docker_tap_up.sh

docker-compose down
docker-compose up -d -f docker-compose.yml -f docker-compose-osx.yml

CONSUL_NETWORK_ID=`docker network ls | grep consul | head -1 | awk '{print $1}'`
CONSUL_NETWORK_IP=`docker inspect $CONSUL_NETWORK_ID | python -c "import sys, json; print(json.load(sys.stdin)[0]['IPAM']['Config'][0]['Subnet'][0:10])"`

# Add Route
sudo route -n delete -net $CONSUL_NETWORK_IP
sudo route -n add -net $CONSUL_NETWORK_IP -netmask 255.255.0.0 10.0.75.2