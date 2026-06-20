ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

USER root

LABEL org.opencontainers.image.title="Jitsi Meet"
LABEL org.opencontainers.image.description="WebRTC compatible JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences."
LABEL org.opencontainers.image.url="https://jitsi.org/jitsi-meet/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
COPY rootfs/ /

RUN \
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    cron \
    dnsutils \
    jitsi-meet-web \
    jq \
    nginx-extras \
    socat \
    && \
  mv /usr/share/jitsi-meet/interface_config.js /defaults && \
  chmod 0755 /opt/acme.sh && \
  ln -s /run/web/.well-known /usr/share/jitsi-meet/.well-known && \
  rm -f /etc/nginx/conf.d/default.conf && \
  rm -rf /var/lib/nginx && \
  ln -s /run/web/tmp /var/lib/nginx && \
  mkdir -p /storage && \
  chown s6:s6 /storage && \
  apt-cleanup

EXPOSE 8000 8443

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

USER s6
