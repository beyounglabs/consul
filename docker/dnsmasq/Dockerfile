FROM jpillora/dnsmasq:latest

COPY entrypoint.sh /etc/entrypoint.sh

COPY dnsmasq.conf /etc/dnsmasq.conf.template

RUN chmod +x /etc/entrypoint.sh

ENTRYPOINT [ "/etc/entrypoint.sh" ]