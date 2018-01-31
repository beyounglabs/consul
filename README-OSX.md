# Installing on OSX

## Installing

### Create the consul network:
```
docker network create consul
```

### Clone the project:

```
git clone git@github.com:beautybrands/consul.git
```

### Enter on the folder and run Docker Compose:

```
docker-compose up -d
```

### Installing tuntap

```
brew tap caskroom/cask
brew cask install tuntap
git clone git@github.com:AlmirKadric-Published/docker-tuntap-osx.git ~/docker-tuntap-osx
~/docker-tuntap-osx/sbin/docker_tap_install.sh
```

### Turn up the tuntap interface

This command MUST run every Docker restart:

```
~/docker-tuntap-osx/sbin/docker_tap_up.sh
```

### Add the local route to tuntap interface

Discover the IP of consul container:

```
docker inspect consul | python -c "import sys, json; print(json.load(sys.stdin)[0]['NetworkSettings']['Networks']['consul']['IPAddress'])"
```

In my case is: 172.18.0.3, so run this command to add the route:
```
sudo route -n add -net 172.18.0.0 -netmask 255.255.0.0 10.0.75.2
```

### Add the local DNS to MAC
Add 127.0.0.1 to DNS in Network Manager

## Debugging
To see a list of useful commands: 
https://github.com/AlmirKadric-Published/docker-tuntap-osx/issues/7#issuecomment-350550862

To list routes:
```
netstat -rn
```