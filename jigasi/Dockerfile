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

RUN mkdir /config
RUN mkdir -pm777 /tmp/transcripts

RUN chown -R noroot:noroot /etc/cont-init.d
RUN chown -R noroot:noroot /etc/services.d
RUN chown -R noroot:noroot /tmp
RUN chown -R noroot:noroot /run
RUN chown -R noroot:noroot /config
RUN chown -R noroot:noroot /var
RUN chown -R noroot:noroot /usr/share
RUN chown -R noroot:noroot /defaults
RUN chmod +x /etc/cont-init.d/*
RUN chmod +x /etc/services.d/jigasi/*
RUN chmod +x /usr/share/jigasi/jigasi.sh

USER noroot

VOLUME ["/config", "/tmp/transcripts"]
