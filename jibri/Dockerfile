ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Broadcasting Infrastructure (jibri)"
LABEL org.opencontainers.image.description="Components for recording and/or streaming a conference."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jibri"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ARG TARGETPLATFORM
ARG USE_CHROMIUM=0
#ARG CHROME_RELEASE=latest
#ARG CHROMEDRIVER_MAJOR_RELEASE=latest
ARG CHROME_RELEASE=114.0.5735.90
ARG CHROMEDRIVER_MAJOR_RELEASE=114

COPY --chown=noroot:noroot rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" jibri libgl1-mesa-dri procps jitsi-upload-integrations jitsi-autoscaler-sidecar jq pulseaudio dbus dbus-x11 rtkit unzip fonts-noto && \
    /usr/bin/install-chrome.sh && \
    apt-cleanup

RUN mkdir -p /etc/jitsi/autoscaler-sidecar
RUN mkdir -p /config/logs
RUN mkdir -p /config/recordings
RUN mkdir -p /jibri

RUN chown -R noroot:noroot /etc/cont-init.d
RUN chown -R noroot:noroot /etc/services.d
RUN chown -R noroot:noroot /etc/jitsi
RUN chown -R noroot:noroot /run
RUN chown -R noroot:noroot /jibri
RUN chown -R noroot:noroot /config
RUN chown -R noroot:noroot /var
RUN chown -R noroot:noroot /opt/jitsi
RUN chown -R noroot:noroot /tmp
RUN chown -R noroot:noroot /defaults
RUN chown -R noroot:noroot /usr/bin
RUN chmod +x /etc/cont-init.d/*
RUN chmod +x /etc/services.d/10-xorg/*
RUN chmod +x /etc/services.d/20-icewm/*
RUN chmod +x /etc/services.d/30-pulse/*
RUN chmod +x /etc/services.d/40-jibri/*
RUN chmod +x /etc/services.d/50-autoscaler-sidecar/*
RUN chmod +x /opt/jitsi/jibri/launch.sh

USER noroot

VOLUME /config
