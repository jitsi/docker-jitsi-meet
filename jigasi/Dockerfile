LABEL org.opencontainers.image.title="Jitsi Gateway to SIP (jigasi)"
LABEL org.opencontainers.image.description="Server-side application that allows regular SIP clients to join conferences."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jigasi"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

ENV GOOGLE_APPLICATION_CREDENTIALS /config/key.json

# Jigasi doesn't yet work well with Java 11, let's ccontinue to use 8.

RUN mkdir -p /usr/share/man/man1 && \
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | gpg --dearmour > /etc/apt/trusted.gpg.d/openjdk.gpg && \
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ bullseye main" > /etc/apt/sources.list.d/openjdk.list && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y adoptopenjdk-8-hotspot-jre && \
    apt-dpkg-wrap apt-get install -y jigasi jq && \
    apt-cleanup

COPY rootfs/ /

VOLUME ["/config", "/tmp/transcripts"]
