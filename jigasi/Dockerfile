ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Gateway to SIP (jigasi)"
LABEL org.opencontainers.image.description="Server-side application that allows regular SIP clients to join conferences."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jigasi"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV GOOGLE_APPLICATION_CREDENTIALS /config/key.json

# Jigasi doesn't yet work well with Java 11, let's ccontinue to use 8.
ARG OPENJDK_GPG_KEY_URL="https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public"
ARG OPENJDK_GPG_FINGERPRINT="8ED17AF5D7E675EB3EE3BCE98AC3B29174885C03"
RUN set -eux; \
    mkdir -p /usr/share/man/man1; \
    wget -qO /tmp/adoptopenjdk.gpg.key "${OPENJDK_GPG_KEY_URL}"; \
    gpg --import /tmp/adoptopenjdk.gpg.key; \
    rm /tmp/adoptopenjdk.gpg.key; \
    gpg --export "${OPENJDK_GPG_FINGERPRINT}" > /etc/apt/trusted.gpg.d/openjdk.gpg; \
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ bullseye main" > /etc/apt/sources.list.d/openjdk.list; \
    apt-dpkg-wrap apt-get update; \
    apt-dpkg-wrap apt-get install -y adoptopenjdk-8-hotspot-jre jigasi jq; \
    apt-cleanup;

COPY rootfs/ /

VOLUME ["/config", "/tmp/transcripts"]
