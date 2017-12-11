# Configuring Environment

## About

The purpose of this project is provide a setup to run consul in local enviroment.

## Install

Disable local DNS:

```
sudo systemctl disable systemd-resolved && sudo systemctl stop systemd-resolved
```

Update your /etc/default/docker file to use local DNS and add DNS Search to service.consul. Your DOCKER_OPTS option should be something like:

```
DOCKER_OPTS="--dns 172.17.0.1 --dns 8.8.8.8 --dns-search service.consul"
```

Create consul network:

```
docker network create consul
```

Run Docker Compose.

```
docker-compose up -d
```

Change /etc/resolv.conf

```
nameserver 127.0.0.1
```

You should be able to see Consul UI at http://consul.service.consul:8500

Now, whenever a container start running you should be able to see it on Consul UI and access it using its name followed by service.consul. You can add some tags for hint Consul for configs.

The docker-compose.example.yml can be used as reference.

## Backing local DNS:

```
sudo systemctl start systemd-resolved && sudo systemctl enable systemd-resolved
```