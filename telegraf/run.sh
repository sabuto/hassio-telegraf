#!/usr/bin/env bashio

if bashio::config.true 'docker.enabled'; then
  bashio::require.unprotected
fi

if bashio::config.true 'smart_monitor'; then
  bashio::require.unprotected
fi

readonly CONFIG="/etc/telegraf/telegraf.conf"

INFLUX_SERVER=$(bashio::config 'influxDB')
INFLUX_DB=$(bashio::config 'influx_db')
INFLUX_UN=$(bashio::config 'influx_user')
INFLUX_PW=$(bashio::config 'influx_pw')
RETENTION=$(bashio::config 'retention_policy')
DOCKER_TIMEOUT=$(bashio::config 'docker.timeout')
SMART_TIMEOUT=$(bashio::config 'smart_monitor.timeout')
IPMI_USER=$(bashio::config 'ipmi_sensor.server_user_id')
IPMI_PASSWORD=$(bashio::config 'ipmi_sensor.server_password')
IPMI_PROTOCOL=$(bashio::config 'ipmi_sensor.server_protocol')
IPMI_IP=$(bashio::config 'ipmi_sensor.server_ip')
IPMI_INTERVAL=$(bashio::config 'ipmi_sensor.interval')
IPMI_TIMEOUT=$(bashio::config 'ipmi_sensor.timeout')

bashio::log.info "Updating config"

sed -i "s,http://a0d7b954-influxdb:8086,${INFLUX_SERVER},g" $CONFIG

sed -i "s,TELEGRAF_DB,${INFLUX_DB},g" $CONFIG

sed -i "s,INFLUX_UN,${INFLUX_UN},g" $CONFIG

sed -i "s,INFLUX_PW,${INFLUX_PW},g" $CONFIG

sed -i "s,RETENTION,${RETENTION},g" $CONFIG

if bashio::config.true 'kernel.enabled'; then
  bashio::log.info "Updating config for Kernel"
  {
    echo "[[inputs.kernel]]"
  } >> $CONFIG
fi

if bashio::config.true 'swap.enabled'; then
  bashio::log.info "Updaing config for Swap"
  {
    echo "[[inputs.swap]]"
  } >> $CONFIG
fi

if bashio::config.true 'docker.enabled'; then
  bashio::log.info "Updating config for Docker"
  {
    echo "[[inputs.docker]]"
    echo "  endpoint = 'unix:///var/run/docker.sock'"
    echo "  timeout = 'DOCKER_TIMEOUT'"
  } >> $CONFIG

  sed -i "s,DOCKER_TIMEOUT,${DOCKER_TIMEOUT},g" $CONFIG
fi

if bashio::config.true 'smart_monitor.enabled'; then
  bashio::log.info "Updating config for Smart Monitor"
  {
    echo "[[inputs.smart]]"
    echo "  timeout = 'SMART_TIMEOUT'"
  } >> $CONFIG

  sed -i "s,SMART_TIMEOUT,${SMART_TIMEOUT},g" $CONFIG
fi

if bashio::config.true 'ipmi_sensor.enabled'; then
  bashio::log.info "Updating config for ipmi sensor"
  {
    echo "[[inputs.ipmi_sensor]]"
    echo "  servers = ['USER_ID:PASSWORD@PROTOCOL(IP)']"
    echo "  interval = 'INTERVAL'"
    echo "  timeout = 'TIMEOUT'"
  } >> $CONFIG

  sed -i "s,USER_ID,${IPMI_USER},g" $CONFIG
  sed -i "s,PASSWORD,${IPMI_PASSWORD},g" $CONFIG
  sed -i "s,PROTOCOL,${IPMI_PROTOCOL},g" $CONFIG
  sed -i "s,IP,${IPMI_IP},g" $CONFIG
  sed -i "s,INTERVAL,${IPMI_INTERVAL},g" $CONFIG
  sed -i "s,TIMEOUT,${IPMI_TIMEOUT},g" $CONFIG
fi

bashio::log.info "Finished updating config, Starting Telegraf"

telegraf
