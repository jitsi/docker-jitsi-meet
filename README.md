# Jitsi Meet on Docker

[Jitsi] is a set of Open Source projects that allows you to easily build and deploy secure
videoconferencing solutions.

[Jitsi Meet] is a fully encrypted, 100% Open Source videoconferencing solution that you can use
all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker] using
[Docker Compose].

**NOTE: This setup is experimental.**

## Quick start

In order to quickly run Jitsi Meet on a machine running Docker and Docker Compose,
follow these steps:

* Create a ``.env`` file by copying and adjusting ``env.example``.
* Run ``docker-compose up -d``.
* Access the web UI at ``https://localhost:8443`` (or a different port, in case you edited
the compose file yourself.

## Architecture

A Jitsi Meet installation can be broken down into the following components:

* A web interface
* An XMPP server
* A conference focus component
* A video router (could be more than one)

![](resources/docker-jitsi-meet.png)

The diagram shows a typical deployment in a host running Docker, with a separate container
(not included in this project) which acts as a reverse proxy and SSL terminator, then
passing the traffic to the web container serving Jitsi Meet.

This project separates each of the components above into interlinked containers. To this end,
several container images are provided.

### Images

* **base**: Debian stable base image with the [S6 Overlay] for process control and the
  [Jitsi repositories] enabled. All other images are based off this one.
* **base-java**: Same as the above, plus Java (OpenJDK).
* **web**: Jitsi Meet web UI, served with nginx.
* **prosody**: [Prosody], the XMPP server.
* **jicofo**: [Jicofo], the XMPP focus component.
* **jvb**: [Jitsi Videobridge], the video router.

Note: see the README on each image for a description of all possible configuration options.
Not all of them need to be set for a compose setup, please check ``docker-compose.yml`` and
``env.example`` for the required ones.

### Design considerations

Jitsi Meet uses XMPP for signalling, thus the need for the XMPP server. The setup provided
by these containers does not expose the XMPP server to the outside world. Instead, it's kept
completely sealed, and routing of XMPP traffic only happens on a user defined network.

The XMPP server can be exposed to the outside world, but that's out of the scope of this
project.

## Configuration

The following variables can be set in the ``.env`` file to customize the installation:

* ``CONFIG=/opt/jitsi-meet-cfg`` - Volume where the configuration of all the containers will
  be stored.
* ``DOCKER_HOST_ADDRESS=192.168.1.1`` - IP address of the host running Docker. See the "Running
  on a LAN environment" section for more details.
* ``TZ=Europe/Amsterdam`` - System time zone.
* ``XMPP_DOMAIN=meet.jitsi`` - Domain for the XMPP server. The default works fine, since
  the server is only accessible via the internal container network.
* ``JVB_COMPONENT_SECRET=s3cr3t`` - Password used by the Jitsi Videobridge when connecting
  to the XMPP server as a component.
* ``JVB_STUN_SERVERS=stun.l.google.com:19302,stun1.l.google.com:19302,stun2.l.google.com:19302`` - STUN
  servers used to harvest the public IP address.
* ``JICOFO_COMPONENT_SECRET=s3cr37`` - Password used by Jicodo when connecting to the XMPP server
  as a component.
* ``JICOFO_AUTH_USER=focus`` - Username used by Jocofo when connecting to the XMPP server
  as a client.
* ``JICOFO_AUTH_PASSWORD=passw0rd`` - Password used by Jicofo when connecting to the XMPP
  server as a client.

### Running on a LAN environment

If running in a LAN environment (as well as on the public Internet, via NAT-es ports) is a requirement,
the ``DOCKER_HOST_ADDRESS`` should be set. This way, the Videobridge will advertise the IP address
of the host running Docker instead of the internal IP address that Docker assigned it, thus making [ICE]
succeed.

The public IP address is discovered via [STUN]. STUN servers can be specified with the ``JVB_STUN_SERVERS``
option.

## Limitations

* Currently a single Jitsi Videobridge is supported.
* Multiple container replicas are not supported.
* Docker Swarm mode is not yet supported.


[Jitsi]: https://jitsi.org/
[Jitsi Meet]: https://jitsi.org/jitsi-meet/
[Docker]: https://www.docker.com
[Docker Compose]: https://docs.docker.com/compose/
[Swarm mode]: https://docs.docker.com/engine/swarm/
[S6 Overlay]: https://github.com/just-containers/s6-overlay
[Jitsi repositories]: https://jitsi.org/downloads/
[Prosody]: https://prosody.im/
[Jicofo]: https://github.com/jitsi/jicofo
[Jitsi Videobridge]: https://github.com/jitsi/jitsi-videobridge
[ICE]: https://en.wikipedia.org/wiki/Interactive_Connectivity_Establishment
[STUN]: https://en.wikipedia.org/wiki/STUN

