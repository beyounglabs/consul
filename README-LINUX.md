# Installing on Linux

## Installing

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

Clone the project:

```
git clone git@github.com:beautybrands/consul.git
```

Enter on the folder and run:

```
./start.sh
```