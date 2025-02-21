ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

USER root

COPY rootfs /

RUN \
  wget -qO - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmour >/usr/share/keyrings/nodesource.gpg && \
\
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    nodejs \
    openjdk-17-jdk-headless \
    openjdk-17-jre-headless \
    && \
  apt-cleanup

USER s6
