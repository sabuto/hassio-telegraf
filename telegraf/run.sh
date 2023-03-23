#!/usr/bin/env bashio
declare influx_un
declare influx_pw
declare influx_ret
declare hostname
bashio::require.unprotected

readonly CONFIG="/etc/telegraf/telegraf.conf"

HOSTNAME=$(bashio::config 'hostname')
AGENT_INTERVAL=$(bashio::config 'telegraf_agent.interval')
INFLUX_SERVER=$(bashio::config 'influxDB.url')
INFLUX_DB=$(bashio::config 'influxDB.db')
INFLUX_UN=$(bashio::config 'influxDB.username')
INFLUX_PW=$(bashio::config 'influxDB.password')
INFLUXDBV2_URL=$(bashio::config 'influxDBv2.url')
INFLUXDBV2_TOKEN=$(bashio::config 'influxDBv2.token')
INFLUXDBV2_ORG=$(bashio::config 'influxDBv2.organization')
INFLUXDBV2_BUCKET=$(bashio::config 'influxDBv2.bucket')
RETENTION=$(bashio::config 'influxDB.retention_policy')
DOCKER_TIMEOUT=$(bashio::config 'docker.timeout')
SMART_TIMEOUT=$(bashio::config 'smart_monitor.timeout')
IPMI_USER=$(bashio::config 'ipmi_sensor.server_user_id')
IPMI_PASSWORD=$(bashio::config 'ipmi_sensor.server_password')
IPMI_PROTOCOL=$(bashio::config 'ipmi_sensor.server_protocol')
IPMI_IP=$(bashio::config 'ipmi_sensor.server_ip')
IPMI_INTERVAL=$(bashio::config 'ipmi_sensor.interval')
IPMI_TIMEOUT=$(bashio::config 'ipmi_sensor.timeout')
CUSTOM_CONF_ENABLED=$(bashio::config 'custom_conf.enabled')
CUSTOM_CONF=$(bashio::config 'custom_conf.location')


if bashio::var.true "${CUSTOM_CONF_ENABLED}"; then
  bashio::log.info "Using custom conf file"
  rm /etc/telegraf/telegraf.conf
  cp "${CUSTOM_CONF}" /etc/telegraf/telegraf.conf
else
  bashio::log.info "Updating config"

  if bashio::var.has_value "${HOSTNAME}"; then
    hostname="hostname = 'HOSTNAME'"
  else
    hostname=" hostname = ''"
  fi

  if bashio::var.has_value "${AGENT_INTERVAL}"; then
    agent_interval="interval = 'AGENT_INTERVAL'"
  else
    agent_interval=" interval = '10s'"
  fi

  {
    echo "[agent]"
    echo "  ${agent_interval}"
    echo "  round_interval = true"
    echo "  metric_batch_size = 1000"
    echo "  metric_buffer_limit = 10000"
    echo "  collection_jitter = \"0s\""
    echo "  flush_interval = \"10s\""
    echo "  flush_jitter = \"0s\""
    echo "  precision = \"\""
    echo "  ${hostname}"
    echo "  omit_hostname = false"
  } >> $CONFIG

  sed -i "s,HOSTNAME,${HOSTNAME},g" $CONFIG
  sed -i "s,AGENT_INTERVAL,${AGENT_INTERVAL},g" $CONFIG

  if bashio::config.true 'influxDB.enabled'; then
    if bashio::var.has_value "${INFLUX_UN}"; then
      influx_un="  username='INFLUX_UN'"
    else
      influx_un="  # INFLUX_UN"
    fi

    if bashio::var.has_value "${INFLUX_PW}"; then
      influx_pw="  password='INFLUX_PW'"
    else
      influx_pw="  # INFLUX_PW"
    fi

    if bashio::var.has_value "${RETENTION}"; then
      influx_ret="  retention_policy='RETENTION'"
    else
      influx_ret="  # RETENTION"
    fi

    {
      echo "[[outputs.influxdb]]"
      echo "  urls = ['http://a0d7b954-influxdb:8086']"
      echo "  database = \"TELEGRAF_DB\""
      echo "  ${influx_ret}"
      echo "  timeout = '5s'"
      echo "  ${influx_un}"
      echo "  ${influx_pw}"
    } >> $CONFIG

    sed -i "s,http://a0d7b954-influxdb:8086,${INFLUX_SERVER},g" $CONFIG

    sed -i "s,TELEGRAF_DB,${INFLUX_DB},g" $CONFIG

    sed -i "s,INFLUX_UN,${INFLUX_UN},g" $CONFIG

    sed -i "s,INFLUX_PW,${INFLUX_PW},g" $CONFIG

    sed -i "s,RETENTION,${RETENTION},g" $CONFIG

  fi

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
      echo "  servers = [\"USER_ID:PASSWORD@PROTOCOL(IP)\"]"
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

  if bashio::config.true 'thermal.enabled'; then
    bashio::log.info "Updating config for thermal zone sensors"
    for i in $(shopt -s nullglob; echo /sys/class/thermal/thermal_zone*); do
      bashio::log.info "...$i"
      name=$(basename "$i")
      {
        echo "[[inputs.file]]"
        echo "  files = [\"$i/temp\"]"
        echo "  name_override = \"$name\""
        echo "  data_format = \"value\""
        echo "  data_type = \"integer\""
      } >> $CONFIG
    done
  fi

  if bashio::config.true 'influxDBv2.enabled'; then
    bashio::log.info "Updating config for influxdbv2"
    {
      echo "[[outputs.influxdb_v2]]"
      echo "  urls = [\"INFLUXv2_URL\"]"
      echo "  token = 'INFLUX_TOKEN'"
      echo "  organization = 'INFLUX_ORG'"
      echo "  bucket = 'INFLUX_BUCKET'"
    } >> $CONFIG

    sed -i "s,INFLUXv2_URL,${INFLUXDBV2_URL},g" $CONFIG
    sed -i "s,INFLUX_TOKEN,${INFLUXDBV2_TOKEN},g" $CONFIG
    sed -i "s,INFLUX_ORG,${INFLUXDBV2_ORG},g" $CONFIG
    sed -i "s,INFLUX_BUCKET,${INFLUXDBV2_BUCKET},g" $CONFIG
  fi

  if bashio::config.true 'prometheus.enabled'; then
    bashio::log.info "Updating config for prometheus client"
    {
      echo "[[outputs.prometheus_client]]"
      echo "  listen = \":9273\""
      echo "  path   = \"PROM_METRICS_PATH\""
      echo "  metric_version = 2"
    } >> $CONFIG

    PROM_METRICS_PATH="$( bashio::config 'prometheus.metrics_path' )"
    sed -i "s,PROM_METRICS_PATH,${PROM_METRICS_PATH},g" $CONFIG
  fi

fi

bashio::log.info "Finished updating config, Starting Telegraf"

telegraf
