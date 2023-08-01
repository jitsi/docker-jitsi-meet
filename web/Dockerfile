ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Meet"
LABEL org.opencontainers.image.description="WebRTC compatible JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences."
LABEL org.opencontainers.image.url="https://jitsi.org/jitsi-meet/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/2.8.8/acme.sh /opt
COPY --chown=noroot:noroot rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y cron nginx-extras jitsi-meet-web socat curl jq && \
    mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf && \
    apt-cleanup

RUN chown -R noroot:noroot /etc/cont-init.d
RUN chown -R noroot:noroot /etc/services.d
RUN chown -R noroot:noroot /var
RUN chown -R noroot:noroot /run
RUN mkdir -p /config && chown -R noroot:noroot /config
RUN chmod +x /etc/cont-init.d/*
RUN chmod +x /etc/services.d/cron/*
RUN chmod +x /etc/services.d/jaas-account/*
RUN chmod +x /etc/services.d/nginx/*

EXPOSE 80 443

USER noroot

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]
