ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base:${BASE_TAG}

RUN <<-EOF
    set -x
    mkdir -p /usr/share/man/man1
    mkdir -p /etc/apt/keyrings
    wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public > /etc/apt/keyrings/adoptium.asc
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/adoptium.list
    apt-dpkg-wrap apt-get update
    apt-dpkg-wrap apt-get install -y temurin-11-jre
    apt-cleanup
EOF
