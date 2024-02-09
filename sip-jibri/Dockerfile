# ------------------------------------------------------------------------------
# builder
# ------------------------------------------------------------------------------
ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG} as builder

ARG PROJECT_REPO=https://github.com/jitsi/pjproject
ARG PROJECT_BRANCH=jibri-2.13-dev1

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        build-essential git \
        libv4l-dev libsdl2-dev libavcodec-dev libavdevice-dev libavfilter-dev \
        libavformat-dev libavresample-dev libavutil-dev libswresample-dev \
        libswscale-dev libasound2-dev libopus-dev libvpx-dev && \
    cd /tmp && \
    git clone -b $PROJECT_BRANCH $PROJECT_REPO && \
    cd pjproject && ./configure && make dep && make && \
    cp pjsip-apps/bin/pjsua-x86_64-unknown-linux-gnu /tmp/pjsua && \
    apt-cleanup

# ------------------------------------------------------------------------------
# sip-jibri
# ------------------------------------------------------------------------------
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

COPY --from=builder /tmp/pjsua /usr/local/bin/pjsua
COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        jibri libgl1-mesa-dri jitsi-autoscaler-sidecar jq dbus dbus-x11 rtkit \
        unzip fonts-noto && \
    apt-dpkg-wrap apt-get install -y \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        libv4l-0 unclutter && \
    /usr/bin/install-chrome.sh && \
    /usr/bin/install-pjsua.sh && \
    apt-cleanup && \
    adduser jibri rtkit && \
    update-alternatives --install /usr/bin/google-chrome google-chrome \
        /usr/local/bin/google-chrome 300

EXPOSE 5060

VOLUME /config
