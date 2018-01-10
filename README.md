# Consul for Docker

## About

The purpose of this project is to provide a setup to run consul in a local enviroment using docker.

This repository assumes you have `docker`, `docker-compose` and `git` installed.

## Installing

Disable local DNS:

```
sudo systemctl disable systemd-resolved && sudo systemctl stop systemd-resolved
```

On Fedora, also run this command:

```
sudo systemctl disable dnsmasq && sudo systemctl stop dnsmasq
```

Update your `/etc/default/docker` file to use local DNS and add DNS Search to `service.consul`.

Your `DOCKER_OPTS` option should be something like:

```
DOCKER_OPTS="--dns 172.17.0.1 --dns 8.8.8.8 --dns-search service.consul"
```

Update your `/etc/systemd/system/multi-user.target.wants/docker.service` file to use `/etc/default/docker`.

Add the EnvironmentFile e update the ExecStart:

```
[Service]
EnvironmentFile=/etc/default/docker
ExecStart=/usr/bin/dockerd -H fd:// $DOCKER_OPTS
```

Reload Systemctl daemon:

```
sudo systemctl daemon-reload
```

Restart the Docker daemon:

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

Enter on the folder and run Docker Compose:

```
docker-compose up -d
```

Change `/etc/resolv.conf`:

```
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
```

On Fedora, you need to change the DNS in the Network Manager GUI to `127.0.0.1`, `8.8.8.8` and `8.8.4.4`.

## Using

You should be able to see Consul UI at http://consul.service.consul:8500.

Now, whenever a container starts running, you should be able to see it on Consul UI and access it using its name followed by `service.consul`.

You can add some tags on `enviroment` configo to hint Consul. See the [docker-compose.example.yml](docker-compose.example.yml) for reference. Based on the example you would access http://example-redis.service.consul.

If the container is a http based container, like NGINX, you can use `SERVICE_NAME.develop` domain with port 80 or 3000. Accessing http://my-node.develop:3000 will redirect to http://my-node.service.consul:3000.

If you need to use a subdomain, you can use http://mysubdomain.my-node.develop:3000 and this will also redirect to http://my-node.service.consul:3000.

## Backing local DNS:

```
sudo systemctl start systemd-resolved && sudo systemctl enable systemd-resolved
```

On Fedora, also run this command:

```
sudo systemctl start dnsmasq && sudo systemctl enable dnsmasq
```
