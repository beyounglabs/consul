# Configuring Environment

Install dnsmasq application running the following command:

```apt-get install dnsmasq```

Map dnsmasq to resolve .consul DNS to Consul DNS (You should use your own docker0 address if it is not 172.17.0.1):

```echo "server=/consul/172.17.0.1#8600" > /etc/dnsmasq.d/10-consul```

Update your /etc/default/docker file to use local DNS and add DNS Search to service.consul. Your DOCKER_OPTS option should be something like:

```DOCKER_OPTS="--dns 172.17.0.1 --dns 8.8.8.8 --dns-search service.consul"```

Run Docker Compose. 

```docker-compose up -d```

You should be able to see Consul UI at http://consul.service.consul:8500 

Now, whenever a container start running you should be able to see it on Consul UI and access it using its name followed by service.consul. You can
add some tags for hint Consul for configs. Brain's docker compose file can be used by reference:

https://bitbucket.org/beautybrands/brain/src/8b2a0dda91cfe08f4cb674e42f4d76f9579aae58/docker-compose.yml?fileviewer=file-view-default

