ARG JITSI_REPO=ghcr.io/jitsi
ARG BASE_TAG=latest

FROM ${JITSI_REPO}/base:${BASE_TAG} AS builder

USER root

ARG OPUS_TRANSCRIBER_PROXY_REPO=https://github.com/jitsi/opus-transcriber-proxy.git
ARG OPUS_TRANSCRIBER_PROXY_VERSION=main

COPY rootfs/etc/apt/sources.list.d/nodejs.sources /etc/apt/sources.list.d/

RUN \
  wget -qO - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmour > /usr/share/keyrings/nodesource.gpg && \
\
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    build-essential \
    git \
    nodejs \
    python3 \
    && \
\
  git clone --depth 1 --recurse-submodules --shallow-submodules \
    --branch ${OPUS_TRANSCRIBER_PROXY_VERSION} \
    ${OPUS_TRANSCRIBER_PROXY_REPO} /tmp/opus-transcriber-proxy && \
  cd /tmp/opus-transcriber-proxy && \
  npm ci && \
  npm run build:native && \
  npm run build:bundle && \
\
  mkdir -p /opt/opus-transcriber-proxy/dist /opt/opus-transcriber-proxy/build/Release && \
  cp -a package.json package-lock.json /opt/opus-transcriber-proxy/ && \
  cp -a dist/bundle /opt/opus-transcriber-proxy/dist/ && \
  cp -a build/Release/opus_native.node /opt/opus-transcriber-proxy/build/Release/ && \
  cd /opt/opus-transcriber-proxy && \
  npm ci --omit=dev --ignore-scripts

FROM ${JITSI_REPO}/base:${BASE_TAG}

USER root

LABEL org.opencontainers.image.title="Jitsi Opus Transcriber Proxy"
LABEL org.opencontainers.image.description="WebSocket proxy that streams Opus audio to cloud speech-to-text providers."
LABEL org.opencontainers.image.url="https://github.com/jitsi/opus-transcriber-proxy"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

# Native libopus only. The WASM backend is for Cloudflare Workers, which we do not use.
ENV OPUS_BACKEND=native

COPY rootfs/ /

RUN \
  wget -qO - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmour > /usr/share/keyrings/nodesource.gpg && \
\
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    nodejs \
    && \
  apt-cleanup

# Merges into the dist/ placeholders from rootfs.
COPY --from=builder /opt/opus-transcriber-proxy /opt/opus-transcriber-proxy

EXPOSE 8080

USER s6
