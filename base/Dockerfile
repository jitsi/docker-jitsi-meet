FROM docker.io/library/debian:bookworm-slim

ARG JITSI_RELEASE=stable
ARG TARGETPLATFORM
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

COPY rootfs /

RUN <<-EOF
    set -xe
    case ${TARGETPLATFORM} in \
         "linux/amd64")  TPL_ARCH=amd64  ;; \
         "linux/arm64")  TPL_ARCH=arm64  ;; \
    esac
    case ${TARGETPLATFORM} in \
         "linux/amd64")  S6_ARCH=amd64  ;; \
         "linux/arm64")  S6_ARCH=aarch64  ;; \
    esac
    apt-dpkg-wrap apt-get update
    apt-dpkg-wrap apt-get install -y apt-transport-https apt-utils ca-certificates gnupg lsb-release wget
    wget -qO /usr/bin/tpl https://github.com/jitsi/tpl/releases/download/v1.0.4/tpl-linux-${TPL_ARCH}
    wget -qO /tmp/s6.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz
    mkdir /tmp/s6
    tar xfz /tmp/s6.tar.gz -C /tmp/s6
    tar hxfz /tmp/s6.tar.gz -C /
    rm -f /usr/bin/execlineb
    cp /tmp/s6/bin/execlineb /usr/bin/
    rm -rf /tmp/s6*
    wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmour > /etc/apt/trusted.gpg.d/jitsi.gpg
    echo "deb https://download.jitsi.org $JITSI_RELEASE/" > /etc/apt/sources.list.d/jitsi.list
    echo "deb http://ftp.debian.org/debian $(lsb_release -sc)-backports main" > /etc/apt/sources.list.d/backports.list
    apt-dpkg-wrap apt-get update
    apt-dpkg-wrap apt-get dist-upgrade -y
    [ "$JITSI_RELEASE" = "unstable" ] && apt-dpkg-wrap apt-get install -y jq procps curl vim iputils-ping net-tools || true
    apt-cleanup
    chmod +x /usr/bin/tpl
EOF

ENTRYPOINT [ "/init" ]
