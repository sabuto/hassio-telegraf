# Telegraf Plugin for Hassio

[![GitHub Release][releases-shield]][releases]
[![License][license-shield]](LICENSE.md)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

![Travis Ci][travis-shield]
[![Github Activity][commits-shield]][commits]

# Please Note!
Upgrading to 0.5.0 although isn't nessaserily a breaking change, hte config has been adjusted and how it is interprited so please make sure you update the config too!

# Notable mentions

I wanted to mention people/repos that i have borrowed code from to make this work and also who have helped me make this work.

First I wanted to say thanks to [@pvizeli](https://github.com/pvizeli). He helped me with regard to building the image. and just the general work he does on a daily basis

Second I want to say thanks to [@Frenck](https://github.com/frenck). He has helped me a lot on Discord getting this addon working when i was running into errors. His addon for influx db helped me migrate this from Alpine to ubuntu also.

Third I want to say thanks to [@Daniel Welch](https://github.com/danielwelch). I looked at his script for travis builds, he did a write up [here](https://danielwelch.github.io/hassio-dev-env.html) that helped me form a basis of my script.

All of these people are amazing!

# Description

This is a very simple hassio plugin that ebnables you to run telegraf on your hassio system, I am still working on this so please bear with me, I am happy to accept PR's

# Installation

To Install this addon simply go to: Hassio->Addon-store.

Then add https://github.com/Sabuto/hassio-repo in the add repository by URL box.

Scroll down to Rob's Repo and install Telegraf. Give it a few minutes to install and update.

# Config

The config is simple but there are some things to consider,

```yaml
custom_conf:
  enabled: false
  location: /share/telegraf.conf
```

This allows you to specify a custom configuration file so you can add things for yourself if this addon doesn't currently support it. Please note this must be a full telegraf config file not just parts.

```yaml
hostname: ''
```
This allows you set your hostname to something easy

You must have a running influxDB instance (the hassio plugin works)

```yaml
influxDB:
  enabled: true
  url: 'http://a0d7b954-influxdb:8086'
  db: telegraf
  retention_policy: optional
  username: optional
  password: optional
```
This has been moved into it's own block as that made sense with the other options, some have been made optional (previous versions)


```yaml
kernel:
  enabled: true
```

This monitors the kernel

```yaml
swap:
  enabled: true
```

This monitors the swap usasge

```yaml
docker:
  enabled: false
  timeout: 5s
```

This monitors the docker containers

```yaml
smart_monitor:
  enabled: false
  timeout: 30s
```

This allows you to monitor the temperature of the hard drives

```yaml
impi_sensor:
  enabled: false
  interval: 30s
  timeout: 20s
  server_user_id: user
  server_password: password
  server_protocol: lan
  server_ip: 192.168.1.2
```

This allows you to enable the impi settings.

```yaml
influxDBv2:
  enabled: false
  url: 'http://127.0.0.1:9999'
  organization: ''
  token: ''
  bucket: ''
```

This allows you to use InfluxDBv2 if you have an instance running.

```yaml
prometheus:
  enabled: false
  metrics_path: '/metrics'
```
This allows you to use the promethus output

# Known issues

~~For some reason at the moment i have figured out how to communicate with the docker.sock therefore i cannot get the process' for docker contaisners. I will look into this and fix it when i can, if you have any idea please submit a PR~~

# TO-DO

~~Add dev branch~~

Add images to installation steps

~~Add PR Template~~

~~Add Issue Template~~

Configure more options to edit for the inputs

Configure different outputs (so it doesn't have to be influxDB dependant, would appreciate it if people could reccomend ones they would find useful.)

## License

MIT License

Copyright (c) 2019 Robert Dunne

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[commits-shield]: https://img.shields.io/github/commit-activity/y/sabuto/hassio-telegraf?style=plastic
[commits]: https://github.com/sabuto/hassio-telegraf/commits/master
[travis-shield]: https://img.shields.io/travis/sabuto/hassio-telegraf
[releases-shield]: https://img.shields.io/github/v/release/sabuto/hassio-telegraf
[releases]: https://github.com/sabuto/hassio-telegraf/releases
[license-shield]: https://img.shields.io/github/license/sabuto/hassio-telegraf
