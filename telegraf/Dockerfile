ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH=amd64

ENV LANG C.UTF-8

ARG TELEGRAF_VERSION

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends iputils-ping snmp procps lm-sensors smartmontools/bionic-backports ipmitool \
    && ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="armhf"; fi \
    \
    && TELEGRAF="$TELEGRAF_VERSION" \
    && curl -J -L -o /tmp/telegraf.deb \
        "https://dl.influxdata.com/telegraf/releases/telegraf_${TELEGRAF}-1_${ARCH}.deb"
    
    RUN dpkg --install /tmp/telegraf.deb \
    && rm -rf \
        /tmp/* \
        /var/lib/apt/lists/*

EXPOSE 8092/udp 8094 8125/udp

COPY run.sh /
RUN chmod a+x /run.sh
COPY telegraf.conf /etc/telegraf/
RUN chmod a+x /etc/telegraf/telegraf.conf

CMD [ "/run.sh" ]
