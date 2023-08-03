ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Gateway to SIP (jigasi)"
LABEL org.opencontainers.image.description="Server-side application that allows regular SIP clients to join conferences."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jigasi"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV GOOGLE_APPLICATION_CREDENTIALS /config/key.json

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jigasi jq && \
    apt-cleanup

COPY --chown=noroot:noroot rootfs/ /

RUN chown -R noroot:noroot /etc/cont-init.d && \
    chown -R noroot:noroot /etc/services.d && \
    chown -R noroot:noroot /usr/share && \
    chown -R noroot:noroot /defaults && \
    mkdir -pm777 /config/transcripts && \
    mkdir -p /config && chown -R noroot:noroot /config

RUN chmod +x /etc/cont-init.d/* && \
    chmod +x /etc/services.d/jigasi/* && \
    chmod +x /usr/share/jigasi/jigasi.sh

USER noroot

VOLUME /config
