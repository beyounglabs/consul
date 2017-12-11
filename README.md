# Configuring Environment

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

Now, whenever a container start running you should be able to see it on Consul UI and access it using its name followed by service.consul. You can
add some tags for hint Consul for configs. Brain's docker compose file can be used by reference:

https://bitbucket.org/beautybrands/brain/src/8b2a0dda91cfe08f4cb674e42f4d76f9579aae58/docker-compose.yml?fileviewer=file-view-default

## Backing local DNS:

```
sudo systemctl start systemd-resolved && sudo systemctl enable systemd-resolved
```
