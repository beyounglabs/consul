#!/bin/bash

which openssl || apt update 
which openssl || apt install -y openssl

test -f /etc/ssl/private/_develop.key || echo "Generating Certificate .develop"
test -f /etc/ssl/private/_develop.key || openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/_develop.key -out /etc/ssl/certs/_develop.crt -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Local Organization/OU=IT Department/CN=*.develop"

test -f /etc/ssl/private/_local.bbrands.key || echo "Generating Certificate .local.bbrands"
test -f /etc/ssl/private/_local.bbrands.key || openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/_local.bbrands.key -out /etc/ssl/certs/_local.bbrands.crt -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Local Organization/OU=IT Department/CN=*.local.bbrands.com.br"

test -f /etc/ssl/private/_localhost.key || echo "Generating Certificate .localhost"
test -f /etc/ssl/private/_localhost.key || openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/_localhost.key -out /etc/ssl/certs/_localhost.crt -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Local Organization/OU=IT Department/CN=*.localhost"

echo "Starting Nginx"
nginx -g "daemon off;"   