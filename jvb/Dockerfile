ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

USER root

LABEL org.opencontainers.image.title="Jitsi Videobridge (jvb)"
LABEL org.opencontainers.image.description="WebRTC compatible server designed to route video streams amongst participants in a conference."
LABEL org.opencontainers.image.url="https://jitsi.org/jitsi-videobridge/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

RUN \
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    dnsutils \
    jitsi-autoscaler-sidecar \
    jitsi-videobridge2 \
    jq \
    iproute2 \
    libpcap0.8 \
    && \
  apt-cleanup

COPY rootfs/ /

VOLUME /config

USER s6
