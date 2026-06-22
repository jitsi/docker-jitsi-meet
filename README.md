# Jitsi Meet on Docker

![](resources/jitsi-docker.png)

[Jitsi](https://jitsi.org/) is a set of Open Source projects that allows you to easily build and deploy secure videoconferencing solutions.

[Jitsi Meet](https://jitsi.org/jitsi-meet/) is a fully encrypted, 100% Open Source video conferencing solution that you can use all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker](https://www.docker.com) using [Docker Compose](https://docs.docker.com/compose/).

All our images are published on the [GitHub Container Registry (GHCR)](https://github.com/orgs/jitsi/packages).

## Tags

These are the currently published tags for all our images:

Tag | Description
-- | --
`stable` | Points to the latest stable release
`stable-NNNN-X` | A stable release
`unstable` | Points to the latest unstable release
`unstable-YYYY-MM-DD` | Daily unstable release

## Installation

The installation manual is available [here](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker).

### Kubernetes

If you plan to install the jitsi-meet stack on a Kubernetes cluster you can find tools and tutorials in the project [Jitsi on Kubernetes](https://github.com/jitsi-contrib/jitsi-kubernetes).

## TODO

* Builtin TURN server.

## Development

Configure `.env`:
```env
JVB_ADVERTISE_IPS=localhost
JITSI_IMAGE_VERSION=latest
PROSODY_ENABLE_METRICS=true
```

Initialize configuration:
```bash
./gen-passwords.sh
mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
```

Start docker-jitsi-meet:
```
make
docker compose -f docker-compose.yml -f tracing.yml up
```

Shutdown docker-jitsi-meet.

Disable jicofo/jvb service and expose prosody port:
```
prosody:
  ports:
    - 5222:5222
```

For jicofo, modify ~/.jitsi-meet-cfg/jicofo/jicofo.conf
```
xmpp {
  client {
    hostname = "127.0.0.1"
  }
}
```

For jvb, modify ~/.jitsi-meet-cfg/jvb/jvb.conf
```
xmpp-client {
  configs {
    shard0 {
      HOSTNAME = "127.0.0.1"
    }
  }
}
```

For jitsi-meet, do not disable the docker jitsi-meet service. Instead, setup jitsi-meet in development mode, and proxy requests to the docker jitsi-meet server. Also, copy the docker's `config.js` to the local repository.

Run compose and local services.
