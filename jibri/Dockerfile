ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

USER root

LABEL org.opencontainers.image.title="Jitsi Broadcasting Infrastructure (jibri)"
LABEL org.opencontainers.image.description="Components for recording and/or streaming a conference."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jibri"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ARG USE_CHROMIUM=0
#ARG CHROME_RELEASE=latest
# https://googlechromelabs.github.io/chrome-for-testing/
ARG CHROME_RELEASE=130.0.6723.116

COPY rootfs/ /

RUN \
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    dbus \
    dbus-x11 \
    fonts-noto \
    fonts-noto-cjk \
    jibri \
    jitsi-autoscaler-sidecar \
    jitsi-upload-integrations \
    jq \
    libcap2-bin \
    libgl1-mesa-dri \
    procps \
    pulseaudio \
    rtkit \
    unzip \
    && \
  /usr/bin/install-chrome.sh && \
  apt-get purge -y \
    unzip \
    && \
  apt-cleanup && \
\
  rm -rf /etc/jitsi/jibri && \
  ln -s /run/jibri/config /etc/jitsi/jibri && \
\
  usermod -a -G audio,jibri,jitsi,rtkit,video s6 && \
  cp -r /home/jibri/. /home/s6 && \
  rm -rf /home/jibri && \
  ln -s /run/tmp/s6-config /home/s6/.config && \
  ln -s /run/tmp/s6-local /home/s6/.local && \
  chown s6:s6 /home/s6 -R && \
\
  dpkgArch="$(dpkg --print-architecture)" && \
  case "${dpkgArch##*-}" in \
    "amd64") SC_ARCH=x86_64 ;; \
    "arm64") SC_ARCH=aarch64 ;; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac && \
  wget -qO /usr/bin/shm-check https://github.com/saghul/shm-check/releases/download/v1.0.0/shm-check-${SC_ARCH} && \
  chmod +x /usr/bin/shm-check

VOLUME /config

USER s6
