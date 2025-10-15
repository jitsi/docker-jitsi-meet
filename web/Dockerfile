ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:stable-10532-1

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y dnsutils cron nginx-extras jitsi-meet-web socat curl jq && \
    mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf && \
    apt-cleanup

# Runtime config overrides (auto-loaded by the image)
COPY config/custom-config.js           /config/custom-config.js
COPY config/custom-interface_config.js /config/custom-interface_config.js

# Brand assets (replace stock files)
# COPY ./assets/watermark.svg              /usr/share/jitsi-meet/images/watermark.svg
# COPY ./assets/title.html                 /usr/share/jitsi-meet/title.html
# COPY ./assets/favicon.ico                /usr/share/jitsi-meet/images/favicon.ico
# COPY ./assets/apple-touch-icon.png       /usr/share/jitsi-meet/images/apple-touch-icon.png
# COPY ./assets/images/virtual-background/ /usr/share/jitsi-meet/images/virtual-background/
# COPY ./assets/lang/main.json             /usr/share/jitsi-meet/lang/main.json
# COPY ./assets/close2.html                /usr/share/jitsi-meet/static/close2.html


EXPOSE 80 443

# VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]
