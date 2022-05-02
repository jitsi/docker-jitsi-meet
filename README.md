# ![Jitsi Meet on Docker](resources/jitsi-docker.png) Jitsi Meet on Docker

[Jitsi](https://jitsi.org/) is a set of Open Source projects that allows you to easily build and deploy secure videoconferencing solutions.

[Jitsi Meet](https://jitsi.org/jitsi-meet/) is a fully encrypted, 100% Open Source video conferencing solution that you can use all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker](https://www.docker.com)
using [Docker Compose](https://docs.docker.com/compose/).

## Installation

The installation manual is available [here](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker).

**Note:** Due to a bug in the docker version currently in the Debian repos (20.10.5), [Docker does not listen on IPv6 ports](https://forums.docker.com/t/docker-doesnt-open-ipv6-ports/106201/2), so in that case you will have to [manually obtain the latest version](https://docs.docker.com/engine/install/debian/)

### Kubernetes

If you plan to install the jitsi-meet stack on a Kubernetes cluster
you can find tools and tutorials in the project [Jitsi on Kubernetes](https://github.com/jitsi-contrib/jitsi-kubernetes).

## TODO

* Support container replicas (where applicable).
* TURN server.
