# Jitsi Meet on Docker

![](resources/jitsi-docker.png)

[Jitsi](https://jitsi.org/) is a set of Open Source projects that allows you to easily build and deploy secure videoconferencing solutions.

[Jitsi Meet](https://jitsi.org/jitsi-meet/) is a fully encrypted, 100% Open Source video conferencing solution that you can use all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker](https://www.docker.com) using [Docker Compose](https://docs.docker.com/compose/).

## Installation

The installation manual is available [here](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker).

## TODO

* Support container replicas (where applicable).
* TURN server.

## ISSUS
开启 Let's Encrypt 时必映射80端口（HTTP_PORT=80）。否则无法验证证书
WSL环境无法启用录像，因为/dev/** 目录缺失
JVB_STUN_SERVERS 替换为google服务后才能实现多人视频，否则只能1v1