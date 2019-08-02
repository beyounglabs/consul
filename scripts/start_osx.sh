#!/bin/bash

if [ ! "$EUID" -ne 0 ]
  then echo "Please don't run as root"
  exit
fi

# Create Network Consul
[[ $(docker network ls | grep consul) ]] || docker network create consul

NETWORK_INTERFACES=`networksetup -listallhardwareports | grep "Hardware Port" | grep -v "Bluetooth" | grep -v "Thunderbolt"  | sed "s/Hardware Port: //g"`
for NETWORK_INTERFACE in $NETWORK_INTERFACES; do
  sudo networksetup -setdnsservers "$NETWORK_INTERFACE" 8.8.8.8
done

wget -q --spider http://google.com
HAS_INTERNET=false 
if [ $? -eq 0 ]; then
    HAS_INTERNET=true
fi

# Clone Tuntap
[[ -d ./docker-tuntap-osx ]] || echo "Cloning tuntap"
[[ -d ./docker-tuntap-osx ]] || git clone git@github.com:AlmirKadric-Published/docker-tuntap-osx.git ./docker-tuntap-osx

# Update Tun Tap
cd ./docker-tuntap-osx
[[ $HAS_INTERNET ]] && git pull origin master
cd ..

# brew tap caskroom/cask
# brew cask reinstall tuntap

./docker-tuntap-osx/sbin/docker_tap_install.sh

[[ $(ifconfig | grep tap1) ]] || echo "Changing permission /dev/tap1 to $USER"
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
docker-compose  -f docker-compose.yml -f docker-compose-osx.yml up -d

CONSUL_NETWORK_ID=`docker network ls | grep consul | head -1 | awk '{print $1}'`
CONSUL_NETWORK_IP=`docker inspect $CONSUL_NETWORK_ID | python -c "import sys, json; print(json.load(sys.stdin)[0]['IPAM']['Config'][0]['Subnet'][0:10])"`

DNSMASQ_NETWORK_IP=`docker inspect consul_dnsmasq | python -c "import sys, json; print(json.load(sys.stdin)[0]['NetworkSettings']['Networks']['consul']['IPAddress'])"`

# Add Route
echo "Adding Consul IP $CONSUL_NETWORK_IP"
sudo route -n delete -net $CONSUL_NETWORK_IP
sudo route -n add -net $CONSUL_NETWORK_IP -netmask 255.255.0.0 10.0.75.2

for NETWORK_INTERFACE in $NETWORK_INTERFACES; do
  sudo networksetup -setdnsservers "$NETWORK_INTERFACE" $DNSMASQ_NETWORK_IP 8.8.8.8
done

echo "Flushing DNS"
sudo killall -HUP mDNSResponder
sudo killall mDNSResponderHelper
sudo dscacheutil -flushcache