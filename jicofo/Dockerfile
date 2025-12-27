ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Conference Focus (jicofo)"
LABEL org.opencontainers.image.description="Server-side focus component that manages media sessions and acts as load balancer."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jicofo"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

#ARG JICOFO_VERSION=1.0-1167-1

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
        jicofo${JICOFO_VERSION:+=$JICOFO_VERSION} && \
    apt-cleanup

COPY rootfs/ /

VOLUME /config
