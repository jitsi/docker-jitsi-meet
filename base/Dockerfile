FROM debian:bullseye-slim

# install base image dependencies
RUN set -eux; \
    { echo 'APT::Install-Recommends "false";'; echo 'APT::Install-Suggests "false";'; } > /etc/apt/apt.conf.d/99local; \
    echo 'deb http://ftp.debian.org/debian bullseye-backports main' > /etc/apt/sources.list.d/backports.list; \
    apt-get update; \
    apt-get install -y apt-transport-https apt-utils ca-certificates gnupg wget xz-utils; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /var/cache/debconf/* /var/cache/ldconfig/*;

# install s6 overlays
ARG S6_OVERLAY_VERSION=3.1.0.1
ARG S6_OVERLAY_ARCH=x86_64
RUN set -eux; \
    cd /tmp/; \
    wget -q "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
            "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz.sha256" \
            "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz" \
            "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz.sha256" \
            "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" \
            "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz.sha256" \
            "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz" \
            "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz.sha256"; \
    sha256sum -c s6-overlay-noarch.tar.xz.sha256 \
                 s6-overlay-${S6_OVERLAY_ARCH}.tar.xz.sha256 \
                 s6-overlay-symlinks-noarch.tar.xz.sha256 \
                 s6-overlay-symlinks-arch.tar.xz.sha256; \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    tar -C / -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz; \
    tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz; \
    tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz; \
    rm -rf /tmp/s6-overlay-*;

# install jitsi tpl
ARG TPL_VERSION=1.0.1
ARG TPL_ARCH=amd64
RUN set -eux; \
    wget -qO /usr/bin/tpl "https://github.com/jitsi/tpl/releases/download/v${TPL_VERSION}/tpl-linux-${TPL_ARCH}"; \
    chmod 755 /usr/bin/tpl;

# define image environment variables
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# confirm gpg key and setup jitsi repos
ARG JITSI_RELEASE=stable
ARG JITSI_GPG_KEY_URL="https://download.jitsi.org/jitsi-key.gpg.key"
ARG JITSI_GPG_FINGERPRINT="FFD65A0DA2BEBDEB73D44C8BB4D2D216F1FD7806"
RUN set -eux; \
    wget -qO /tmp/jitsi-key.gpg.key "${JITSI_GPG_KEY_URL}"; \
    gpg --import /tmp/jitsi-key.gpg.key; \
    rm /tmp/jitsi-key.gpg.key; \
    gpg --export "${JITSI_GPG_FINGERPRINT}" > /etc/apt/trusted.gpg.d/jitsi.gpg; \
    echo "deb https://download.jitsi.org $JITSI_RELEASE/" > /etc/apt/sources.list.d/jitsi.list; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /var/cache/debconf/* /var/cache/ldconfig/*;

RUN set -eux; \
    test "$JITSI_RELEASE" != "unstable" || { \
        apt-get update; \
        apt-get install -y jq procps curl vim iputils-ping net-tools; \
        rm -rf /var/lib/apt/lists/* /var/cache/apt/* /var/cache/debconf/* /var/cache/ldconfig/*; \
    };

# overlay our base rootfs
COPY rootfs/ /

ENTRYPOINT [ "/init" ]
