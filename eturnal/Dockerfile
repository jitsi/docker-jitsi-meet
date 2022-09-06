FROM debian:bullseye-slim as prepare
# BUILD: define image build arguments
ARG ETURNAL_VERSION=1.10.1
ARG TINI_VERSION=0.19.0

RUN set -x \
    && apt-get update && apt-get install curl -y \ 
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
    && ARCH=$(uname -m | sed -e 's/x86_64/amd64/;s/aarch64/arm64/;s/armv7l/arm/;s/s390x/s390x/;s/ppc64le/ppc64le/') \ 
    && curl -fL -o /rootfs/tini https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini-$ARCH \ 
    && chmod +x /rootfs/tini
# RUNTIME: copy entrypoint script
COPY rootfs /rootfs

FROM busybox:stable-glibc AS eturnal
# BUILD: copy eturnal
COPY --from=prepare --chown=9000:9000 /rootfs /
ARG HOME=/opt/eturnal

RUN set -x \
# RUNTIME: add runtime group and user
    && echo "eturnal:x:9000:eturnal" >> /etc/group \
    && echo "eturnal:x:9000:9000:Linux User,,,:/opt/eturnal:/bin/sh" >> /etc/passwd \
# RUNTIME: create symbolic links, entrypoint script and minimal configuration file
    && ln -s $HOME/bin/eturnalctl /usr/sbin/eturnalctl \
    && ln -s $HOME/bin/stun /usr/sbin/stun \
    && chmod +x /usr/sbin/*

FROM gcr.io/distroless/base-debian11 AS cleanup
# BUILD: copy eturnal
COPY --from=eturnal --chown=9000:9000 / /
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
COPY --from=cleanup --chown=9000:9000 / /
ARG HOME=/opt/eturnal
# RUNTIME: define container runtime environment variables
ENV ERL_DIST_PORT=3470 \
    PIPE_DIR=$HOME/run/pipe/ \
    STUN_SERVICE="stun.conversations.im 3478"

# RUNTIME: define container runtime parameters
WORKDIR $HOME
#USER eturnal
VOLUME ["$HOME"]
EXPOSE 3478 3478/udp
ENTRYPOINT ["/tini","--","run.sh"]
CMD ["eturnalctl", "foreground"]