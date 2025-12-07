ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Videobridge (jvb)"
LABEL org.opencontainers.image.description="WebRTC compatible server designed to route video streams amongst participants in a conference."
LABEL org.opencontainers.image.url="https://jitsi.org/jitsi-videobridge/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

#ARG JITSI_VIDEOBRIDGE_VERSION=2.3-258-g955816e0f-1
#ARG JITSI_AUTOSCALER_SIDECAR_VERSION=1.0-50-g5fef5f5-1

RUN echo $SHELL $JITSI_VIDEOBRIDGE_VERSION && echo && echo && apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
      jitsi-videobridge2${JITSI_VIDEOBRIDGE_VERSION:+=$JITSI_VIDEOBRIDGE_VERSION} \
      jitsi-autoscaler-sidecar${JITSI_AUTOSCALER_SIDECAR_VERSION:+=$JITSI_AUTOSCALER_SIDECAR_VERSION} \
      jq curl iproute2 dnsutils libpcap0.8 && \
    apt-cleanup

COPY rootfs/ /

VOLUME /config
