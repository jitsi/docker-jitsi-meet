ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Videobridge (jvb)"
LABEL org.opencontainers.image.description="WebRTC compatible server designed to route video streams amongst participants in a conference."
LABEL org.opencontainers.image.url="https://jitsi.org/jitsi-videobridge/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jitsi-videobridge2 jq curl iproute2 dnsutils && \
    apt-cleanup

COPY --chown=noroot:noroot rootfs/ /

RUN chown -R noroot:noroot /etc/cont-init.d && \
    chown -R noroot:noroot /etc/services.d && \
    chown -R noroot:noroot /run && \
    chown -R noroot:noroot /var && \
    mkdir -p /config && chown -R noroot:noroot /config

RUN chmod +x /etc/cont-init.d/* && \
    chmod +x /etc/services.d/jvb/*
 
USER noroot

VOLUME /config
