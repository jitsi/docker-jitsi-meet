ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Broadcasting Infrastructure (jibri)"
LABEL org.opencontainers.image.description="Components for recording and/or streaming a conference."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jibri"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ARG USE_CHROMIUM=0
#ARG CHROME_RELEASE=latest
# https://googlechromelabs.github.io/chrome-for-testing/
ARG CHROME_RELEASE=130.0.6723.116

#ARG JIBRI_VERSION=8.0-184-g4f57e90-1
#ARG JITSI_UPLOAD_INTEGRATIONS_VERSION=0.15.15-1
#ARG JITSI_AUTOSCALER_SIDECAR_VERSION=1.0-50-g5fef5f5-1

COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        jibri${JIBRI_VERSION:+=$JIBRI_VERSION} \
        libgl1-mesa-dri \
        procps \
        jitsi-upload-integrations${JITSI_UPLOAD_INTEGRATIONS_VERSION:+=$JITSI_UPLOAD_INTEGRATIONS_VERSION} \
        jitsi-autoscaler-sidecar${JITSI_AUTOSCALER_SIDECAR_VERSION:+=$JITSI_AUTOSCALER_SIDECAR_VERSION} \
        jq \
        pulseaudio \
        dbus \
        dbus-x11 \
        rtkit \
        unzip \
        fonts-noto \
        fonts-noto-cjk \
        libcap2-bin && \
    /usr/bin/install-chrome.sh && \
    apt-cleanup && \
    adduser jibri rtkit && \
    dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        "amd64") SC_ARCH=x86_64 ;; \
        "arm64") SC_ARCH=aarch64 ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    wget -qO /usr/bin/shm-check https://github.com/saghul/shm-check/releases/download/v1.0.0/shm-check-${SC_ARCH} && \
    chmod +x /usr/bin/shm-check

VOLUME /config
