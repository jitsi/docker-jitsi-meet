FROM docker.io/library/debian:bookworm-slim

ARG JITSI_RELEASE=stable
ARG S6_OVERLAY_VERSION=v3.2.0.2
ARG S6_OVERLAY_DOWNLOAD=https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}
ARG TPL_VERSION=v1.4.0
ARG TPL_DOWNLOAD=https://github.com/jitsi/tpl/releases/download/${TPL_VERSION}

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

COPY rootfs /

RUN \
  dpkgArch="$(dpkg --print-architecture)" && \
  case "${dpkgArch##*-}" in \
    "amd64") TPL_ARCH=amd64; S6_ARCH=x86_64 ;; \
    "arm64") TPL_ARCH=arm64; S6_ARCH=aarch64 ;; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac && \
\
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    apt-utils \
    ca-certificates \
    curl \
    gnupg \
    wget \
    && \
  apt-dpkg-wrap apt-get install -y \
    xz-utils \
    && \
\
  wget -qO /usr/bin/tpl ${TPL_DOWNLOAD}/tpl-linux-${TPL_ARCH} && \
  chmod +x /usr/bin/tpl && \
  mkdir /tmp/s6 && \
  wget -qO /tmp/s6/s6-overlay-noarch.tar.xz \
    ${S6_OVERLAY_DOWNLOAD}/s6-overlay-noarch.tar.xz && \
  wget -qO /tmp/s6/s6-overlay-${S6_ARCH}.tar.xz \
    ${S6_OVERLAY_DOWNLOAD}/s6-overlay-${S6_ARCH}.tar.xz && \
  tar -C / -Jxpf /tmp/s6/s6-overlay-noarch.tar.xz && \
  tar -C / -Jxpf /tmp/s6/s6-overlay-${S6_ARCH}.tar.xz && \
  rm -rf /tmp/s6 && \
\
  wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | \
    gpg --dearmour > /usr/share/keyrings/jitsi.gpg && \
  sed -i "s/stable/${JITSI_RELEASE}/" /etc/apt/sources.list.d/jitsi.sources && \
\
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get dist-upgrade -y && \
  apt-get purge -y \
    xz-utils \
    && \
  apt-cleanup && \
\
  adduser --disabled-password --gecos "" s6

RUN \
  [ "${JITSI_RELEASE}" = "unstable" ] && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
      jq \
      iputils-ping \
      net-tools \
      procps \
      vim \
      && \
    apt-cleanup \
  || \
    true

USER s6

ENTRYPOINT [ "/init" ]
