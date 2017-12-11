#!/bin/sh
rm /etc/dnsmasq.conf
cp /etc/dnsmasq.conf.template /etc/dnsmasq.conf
CONSUL_HOST=`getent hosts consul | awk '{ print $1 }'`
getent hosts consul | awk '{ print $1 }' | sed -i "s/CONSUL_HOST/$CONSUL_HOST/" /etc/dnsmasq.conf

webproc --config /etc/dnsmasq.conf -- dnsmasq --no-daemon