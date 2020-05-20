# Jitsi Meet on Docker

![](resources/jitsi-docker.png)

[Jitsi](https://jitsi.org/) is a set of Open Source projects that allows you to easily build and deploy secure videoconferencing solutions.

[Jitsi Meet](https://jitsi.org/jitsi-meet/) is a fully encrypted, 100% Open Source video conferencing solution that you can use all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker](https://www.docker.com) using [Docker Compose](https://docs.docker.com/compose/).

## Installation

Additional Let's Encrypt Settings:

Variable | Description | Example
--- | --- | ---
`ENABLE_LETSENCRYPT_CLOUDFLARE` | Enable Let's Encrypt Cloudflare DNS Api | 1
`LETSENCRYPT_CLOUDFLARE_EMAIL` | Cloudflare E-Mail Adress | alice@atlanta.net
`LETSENCRYPT_CLOUDFLARE_APIKEY` | Cloudflare global API key | 0123456789abcdef0123456789abcdef01234567
`LETSENCRYPT_CLOUDFLARE_PROPAGATION` | Time to wait for DNS propagation completion | 60

Cloudflare API Token can be obtained from https://dash.cloudflare.com/profile/api-tokens 

The installation manual is available [here](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker).

## TODO

* Support container replicas (where applicable).
* TURN server.

