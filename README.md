# Consul for Docker

## About

The purpose of this project is to provide a setup to run consul in a local enviroment using docker.

This repository assumes you have `docker`, `docker-compose` and `git` installed.

## Installing on Linux

To install on Linux, follow this instructions: [README-LINUX.md](README-LINUX.md)

## Installing on OSX

To install on Linux, follow this instructions: [README-OSX.md](README-OSX.md)

## Using

You should be able to see Consul UI at http://consul.service.consul:8500.

Now, whenever a container starts running, you should be able to see it on Consul UI and access it using its name followed by `service.consul`.

You can add some tags on `enviroment` configo to hint Consul. See the [docker-compose.example.yml](docker-compose.example.yml) for reference. Based on the example you would access http://example-redis.service.consul.

If the container is a http based container, like NGINX, you can use `SERVICE_NAME.develop` domain with port 80 or 3000. Accessing http://my-node.develop:3000 will redirect to http://my-node.service.consul:3000.

If you need to use a subdomain, you can use http://mysubdomain.my-node.develop:3000 and this will also redirect to http://my-node.service.consul:3000.

## Debuging DNS Masq

```
docker exec consul_dnsmasq cat /etc/dnsmasq.conf
```
