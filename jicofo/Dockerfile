ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Conference Focus (jicofo)"
LABEL org.opencontainers.image.description="Server-side focus component that manages media sessions and acts as load balancer."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jicofo"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jicofo && \
    apt-cleanup

COPY --chown=noroot:noroot rootfs/ /

RUN chown -R noroot:noroot /etc/cont-init.d && \
    chown -R noroot:noroot /etc/services.d && \
    chown -R noroot:noroot /run && \
    chown -R noroot:noroot /var && \
    chown -R noroot:noroot /usr/share/jicofo && \
    chown -R noroot:noroot /etc/jitsi && \
    chown -R noroot:noroot /etc/jitsi/jicofo && \
    mkdir -p /config && chown -R noroot:noroot /config

RUN chmod +x /usr/share/jicofo/jicofo.sh && \
    chmod +x /etc/cont-init.d/* && \
    chmod +x /etc/services.d/jicofo/*

USER noroot

VOLUME /config
