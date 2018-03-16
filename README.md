# Jitsi Meet on Docker

[Jitsi] is a set of Open Source projects that allows you to easily build and deploy secure
videoconferencing solutions.

[Jitsi Meet] is a fully encrypted, 100% Open Source videoconferencing solution that you can use
all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker] using
[Docker Compose].

**NOTE: This is experimental (at the moment) and running on [Swarm mode] is not yet supported.**

## Quick start

In order to quickly run Jitsi Meet on a machine running Docker and Docker Compose,
follow these steps:

* Create a ``.env`` file by copying and adjusting ``env.example``.
* Run ``docker-compose up -d``.
* Access the web UI at ``https://localhost:8443`` (or a different port, in case you edited
the compose file yourself.

[Jitsi]: https://jitsi.org/
[Jitsi Meet]: https://jitsi.org/jitsi-meet/
[Docker]: https://www.docker.com
[Docker Compose]: https://docs.docker.com/compose/
[Swarm mode]: https://docs.docker.com/engine/swarm/

