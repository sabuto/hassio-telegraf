#!/usr/bin/env bashio

if bashio::config.true 'monitor_docker'; then
  bashio::require.unprotected
fi

readonly CONFIG="/etc/telegraf/telegraf.conf"

INFLUX_SERVER=$(bashio::config 'influxDB')
INFLUX_DB=$(bashio::config 'influx_db')
INFLUX_UN=$(bashio::config 'influx_user')
INFLUX_PW=$(bashio::config 'influx_pw')
RETENTION=$(bashio::config 'retention_policy')
DOCKER_TIMEOUT=$(bashio::config 'docker_timeout')

bashio::log.info "Updating config"

sed -i "s,http://a0d7b954-influxdb:8086,${INFLUX_SERVER},g" $CONFIG

sed -i "s,TELEGRAF_DB,${INFLUX_DB},g" $CONFIG

sed -i "s,INFLUX_UN,${INFLUX_UN},g" $CONFIG

sed -i "s,INFLUX_PW,${INFLUX_PW},g" $CONFIG

sed -i "s,RETENTION,${RETENTION},g" $CONFIG

if bashio::config.true 'monitor_docker'; then
  bashio::log.info "Updating config for Docker"
  {
    echo "[[inputs.docker]]"
    echo "  endpoint = 'unix:///var/run/docker.sock'"
    echo "  timeout = 'DOCKER_TIMEOUT'"
  } >> $CONFIG

  sed -i "s,DOCKER_TIMEOUT,${DOCKER_TIMEOUT},g" $CONFIG
fi

if bashio::config.true 'hdd_temp.enabled'; then
  bashio::log.info "Updating config for HDD temp"
  {
    echo "[[inputs.hddtemp]]"
  } >> $CONFIG
fi

bashio::log.info "Finished updating config, Starting Telegraf"

telegraf
