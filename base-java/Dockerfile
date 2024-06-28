ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

RUN mkdir -p /usr/share/man/man1 && \
    mkdir -p /etc/apt/keyrings/ && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y unzip ca-certificates curl gnupg && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y nodejs openjdk-17-jre-headless openjdk-17-jdk-headless && \
    apt-cleanup
