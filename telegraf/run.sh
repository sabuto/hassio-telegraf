#!/usr/bin/env bashio

if bashio::config.false 'monitor_docker'; then
  bashio::log.info "Using standard config file (no docker)"
  rm /etc/telegraf/telegraf_docker.conf
else
  bashio::require.unprotected
  bashio::log.info "Monitoring docker, moving fikles around!"
  rm /etc/telegraf/telegraf.conf && mv /etc/telegraf/telegraf_docker.conf /etc/telegraf/telegraf.conf
fi

readonly CONFIG="/etc/telegraf/telegraf.conf"

INFLUX_SERVER=$(bashio::config 'influxDB')
INFLUX_DB=$(bashio::config 'influx_db')
INFLUX_UN=$(bashio::config 'influx_user')
INFLUX_PW=$(bashio::config 'influx_pw')
RETENTION=$(bashio::config 'retention_policy')

sed -i "s,http://a0d7b954-influxdb:8086,${INFLUX_SERVER},g" $CONFIG

sed -i "s,TELEGRAF_DB,${INFLUX_DB},g" $CONFIG

sed -i "s,INFLUX_UN,${INFLUX_UN},g" $CONFIG

sed -i "s,INFLUX_PW,${INFLUX_PW},g" $CONFIG

sed -i "s,RETENTION,${RETENTION},g" $CONFIG

bashio::log.info "Influx Server: ${INFLUX_SERVER}"
bashio::log.info "Influx DB: ${INFLUX_DB}"

telegraf
