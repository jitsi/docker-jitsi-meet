ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Video-SIP-Gateway (sip-jibri)"
LABEL org.opencontainers.image.description="Components for joining a conference from a SIP device."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jibri"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ARG TARGETPLATFORM
ARG USE_CHROMIUM=0
#ARG CHROME_RELEASE=latest
# https://googlechromelabs.github.io/chrome-for-testing/
ARG CHROME_RELEASE=116.0.5845.96

COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" jibri libgl1-mesa-dri procps jitsi-autoscaler-sidecar jq pulseaudio dbus dbus-x11 rtkit unzip fonts-noto && \
    apt-dpkg-wrap apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" libv4l-0 && \
    /usr/bin/install-chrome.sh && \
    apt-cleanup && \
    adduser jibri rtkit && \
    update-alternatives --install /usr/bin/google-chrome google-chrome /usr/local/bin/google-chrome 300

VOLUME /config
