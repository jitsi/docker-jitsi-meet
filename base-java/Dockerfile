ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

RUN mkdir -p /usr/share/man/man1 && \
    wget -qO /etc/apt/trusted.gpg.d/openjdk.asc https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public && \
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main" > /etc/apt/sources.list.d/openjdk.list && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y adoptopenjdk-8-hotspot-jre && \
    apt-cleanup
