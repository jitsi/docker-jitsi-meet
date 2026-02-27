ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Gateway to SIP (jigasi)"
LABEL org.opencontainers.image.description="Server-side application that allows regular SIP clients to join conferences."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jigasi"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV GOOGLE_APPLICATION_CREDENTIALS=/config/key.json

#ARG JIGASI_VERSION=1.1-395-g3bb4143-1
#ARG JITSI_AUTOSCALER_SIDECAR_VERSION=1.0-50-g5fef5f5-1

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
        jigasi${JIGASI_VERSION:+=$JIGASI_VERSION} \
        jitsi-autoscaler-sidecar${JITSI_AUTOSCALER_SIDECAR_VERSION:+=$JITSI_AUTOSCALER_SIDECAR_VERSION} \
        jq && \
    apt-cleanup

COPY rootfs/ /

VOLUME ["/config", "/tmp/transcripts"]
