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

RUN mkdir -p /config
RUN chown -R noroot:noroot /etc/cont-init.d
RUN chown -R noroot:noroot /etc/services.d
RUN chown -R noroot:noroot /run
RUN chown -R noroot:noroot /var
RUN chown -R noroot:noroot /usr/share/jicofo
RUN chown -R noroot:noroot /etc/jitsi
RUN chown -R noroot:noroot /etc/jitsi/jicofo
RUN chmod +x /usr/share/jicofo/jicofo.sh
RUN chmod +x /etc/cont-init.d/*
RUN chmod +x /etc/services.d/jicofo/*

RUN chown -R noroot:noroot /config

USER noroot

VOLUME /config
