ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/2.8.8/acme.sh /opt
COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y cron nginx-extras jitsi-meet-web socat && \
    apt-dpkg-wrap apt-get -d install -y jitsi-meet-web-config && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults && \
    mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf && \
    apt-cleanup && \
    rm -rf /tmp/pkg /var/cache/apt

COPY jitsi-meet/css/all.css /usr/share/jitsi-meet/css/all.css
COPY jitsi-meet/images/watermark.svg /usr/share/jitsi-meet/images/watermark.svg
COPY jitsi-meet/interface_config.js /usr/share/jitsi-meet/interface_config.js
EXPOSE 80 443

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]
