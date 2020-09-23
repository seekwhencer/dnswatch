FROM alpine:latest

# fetch dnsmasq
RUN apk update \
 && apk add dnsmasq

#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq

# docker gen
ENV DOCKER_GEN_VERSION 0.7.4
ENV DOCKER_HOST unix:///var/run/docker.sock

RUN wget -qO- https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz | tar xvz -C /usr/local/bin
COPY sys/. /

ENV GATEWAY=192.168.178.1

RUN ["chmod", "+x", "/bin/entrypoint"]
RUN ["chmod", "+x", "/usr/local/bin/docker-gen"]
RUN ["chmod", "+x", "/etc/init.d/dnsmasq"]
RUN ["chmod", "+x", "/bin/dnsmasq-reload"]

#run!
ENTRYPOINT ["su", "root", "-c", "sh /bin/entrypoint"]
