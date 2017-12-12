# Consul for Docker

## About

The purpose of this project is provide a setup to run consul in local enviroment for use with docker.

This repository assumes you have docker, docker-compose and git installed.

**IMPORTANT:** because you setup a DNS server on the dnsmasq docker, if this container is not running, you will no longer hava internet access.

## Install

Disable local DNS:

```
sudo systemctl disable systemd-resolved && sudo systemctl stop systemd-resolved
```

If the distro is Fedora, also run this command:

```
sudo systemctl disable dnsmasq && sudo systemctl stop dnsmasq
```

Update your /etc/default/docker file to use local DNS and add DNS Search to service.consul.
Your DOCKER_OPTS option should be something like:

```
DOCKER_OPTS="--dns 172.17.0.1 --dns 8.8.8.8 --dns-search service.consul"
```

Restart the Docker deamon:

```
sudo systemctl restart docker
```

Create the consul network:

```
docker network create consul
```

Clone the project:

```
git clone git@github.com:beautybrands/consul.git
```

Enter on the folder and run Docker Compose.

```
docker-compose up -d
```

Change /etc/resolv.conf

```
nameserver 127.0.0.1
```

If you are using Fedora, you need to change the DNS in the Network Manager GUI to 127.0.0.1.

## Using

You should be able to see Consul UI at http://consul.service.consul:8500

Now, whenever a container start running, you should be able to see it on Consul UI and access it using its name followed by service.consul.

You can add some tags for hint Consul for configs. The [docker-compose.example.yml](docker-compose.example.yml)
can be used as reference:

```
example-redis.service.consul
```

If the container is a http based container, like NGINX, you can use the .app final in port 80 or 3000:

```
my-node.app:3000
```

This will redirect to:

```
my-node.service.consul:3000
```

If you need use a subdomain, you can use:

```
mysubdomain.my-node.app:3000
```

This also will redirect to:

```
my-node.service.consul:3000
```

## Backing local DNS:

```
sudo systemctl start systemd-resolved && sudo systemctl enable systemd-resolved
```

If the distro is Fedora, also run this command:

```
sudo systemctl start dnsmasq && sudo systemctl enable dnsmasq
```
