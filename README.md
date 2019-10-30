# Telegraf Plugin for Hassio

This is a very simple hassio plugin that ebnables you to run telegraf on your hassio system, I am still working on this so please bear with me, I am happy to accept PR's

# Installation

To Install this addon simply go to: Hassio->Addon-store.

Then add https://github.com/Sabuto/hassio-repo in the add repository by URL box.

Scroll down to Rob's Repo and install Telegraf. Give it a few minutes to install and update.

# Config

The config is simple but there are some things to consider,

You must have a running influxDB instance (the hassio plugin works)

```bash
influxDB
```

This allows you to specify the location and port for your influxDB instance (the port must be specified)

```bash
influx_db
```

This is the database within influxDB to use (you may need to create this)

```bash
influx_user
```

This is the username telegraf will use to communicate with InfluxDB

```bash
influx_pw
```

This is the password to coinside with the username

```bash
retention_policy
```

This is the retention policy to use (again you may need to specify this when setting up the db)

```bash
monitor_docker
```

This allows you to monitor your docker containers, *PLEASE NOTE: IN ORDER TO DO THIS YOU MUST TURN OFF PROTECTION MODE*


# Known issues

~~For some reason at the moment i have figured out how to communicate with the docker.sock therefore i cannot get the process' for docker contaisners. I will look into this and fix it when i can, if you have any idea please submit a PR~~

# TO-DO

~~Add dev branch~~

Add images to installation steps

Add PR Template

~~Add Issue Template~~

Configure more options to edit for the inputs

Configure different outputs (so it doesn't have to be influxDB dependant, would appreciate it if people could reccomend ones they would find useful.)
