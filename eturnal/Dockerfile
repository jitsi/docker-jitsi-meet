FROM debian:bullseye-slim as prepare
# BUILD: define image build arguments
ARG ETURNAL_VERSION=1.10.1
ARG TINI_VERSION=0.19.0
ARG S6_VERSION=v3.1.2.1

RUN set -x \
    && apt-get update && apt-get install apt-transport-https apt-utils ca-certificates curl wget xz-utils -y \ 
# RUNTIME: install eturnal binary with installer
    && ARCH=$(uname -m | sed -e 's/x86_64/x64/;s/aarch64/arm64/;s/armv7l/arm/;s/s390x/s390x/;s/ppc64le/ppc64le/') \ 
    && curl -O https://eturnal.net/download/linux/installer/eturnal-$ETURNAL_VERSION-linux-$ARCH.run \
    && chmod +x eturnal-*.run \
    && ./eturnal-*.run \
    && rm -rf eturnal-*.run /opt/eturnal/etc/* /etc/eturnal.yml \
# RUNTIME: create rootfs with eturnal
    && mkdir -p /rootfs/opt/eturnal/log /rootfs/opt/eturnal/run /rootfs/opt/eturnal/tls \
    && cp -r /opt/eturnal /rootfs/opt \
# RUNTIME: install runtime init
    && ARCH=$(uname -m) \
    && wget -qO - https://github.com/just-containers/s6-overlay/releases/download/$S6_VERSION/s6-overlay-noarch.tar.xz | tar xfJ - -C /rootfs \
    && wget -qO - https://github.com/just-containers/s6-overlay/releases/download/$S6_VERSION/s6-overlay-$ARCH.tar.xz | tar xfJ - -C /rootfs
# RUNTIME: copy s6 scripts
COPY rootfs /rootfs

FROM gcr.io/distroless/base-debian11 AS eturnal
# BUILD: copy eturnal
COPY --from=prepare --chown=9000:9000 /rootfs /
COPY --from=busybox:stable-glibc /bin /bin
ARG HOME=/opt/eturnal

RUN set -x \
# RUNTIME: add runtime group and user
    && echo "eturnal:x:9000:eturnal" >> /etc/group \
    && echo "eturnal:x:9000:9000:Linux User,,,:/opt/eturnal:/bin/sh" >> /etc/passwd \
# RUNTIME: create symbolic links, entrypoint script and minimal configuration file
    && ln -s $HOME/bin/eturnalctl /usr/sbin/eturnalctl \
    && ln -s $HOME/bin/stun /usr/sbin/stun \
    && chmod +x /etc/cont-init.d/* /etc/services.d/*/run

# remove libssl and openssl from distroless image
# as they are statically built within eturnal binary
RUN find -type f -name 'libcrypt*' -exec rm -rv {} + \
    && find -type d -name 'libcrypt*' -exec rm -rv {} + \
    && find -type f -name 'libssl*' -exec rm -rv {} + \
    && find -type d -name 'libssl*' -exec rm -rv {} + \
    && find -type f -name 'openssl*' -exec rm -rv {} + \
    && find -type d -name 'openssl*' -exec rm -rv {} +

FROM scratch AS runtime
# BUILD: copy eturnal
COPY --from=eturnal / /
ARG HOME=/opt/eturnal
# RUNTIME: define environment variables
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    ERL_DIST_PORT=3470 \
    PIPE_DIR=$HOME/run/pipe/ \
    STUN_SERVICE="stun.conversations.im 3478"

# RUNTIME: define container runtime parameters
WORKDIR $HOME
#USER eturnal
VOLUME ["$HOME"]
EXPOSE 3478 3478/udp
ENTRYPOINT ["/init"]
#CMD ["eturnalctl", "foreground"]