ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf

RUN apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata && update-ca-certificates

ENV TELEGRAF_VERSION=1.12.2

RUN set -ex && apk add --no-cache --virtual .build-deps wget gnupg tar && for key in 05CE15085FC09D18E99EFB22684A14CF2582E0C5 ; do gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || gpg --keyserver pgp.mit.edu --recv-keys "$key" || gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; done && wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc && wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && gpg --batch --verify telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && mkdir -p /usr/src /etc/telegraf && tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && chmod +x /usr/src/telegraf*/* && cp -a /usr/src/telegraf*/* /usr/bin/ && rm -rf *.tar.gz* /usr/src /root/.gnupg && apk del .build-deps

EXPOSE 8092/udp 8094 8125/udp

COPY run.sh /
RUN chmod a+x /run.sh
COPY telegraf.conf /etc/telegraf/
COPY telegraf_docker.conf /etc/telegraf/
RUN chmod a+x /etc/telegraf/telegraf.conf
RUN chmod a+x /etc/telegraf/telegraf_docker.conf

CMD [ "/run.sh" ]
