ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest

FROM ${JITSI_REPO}/base:${BASE_TAG} as builder

# install luarocks
ARG LUAROCKS_VERSION=3.8.0
RUN set -eux; \
    apt-dpkg-wrap apt-get update; \
    apt-dpkg-wrap apt-get install -y build-essential lua5.2 liblua5.2-dev libsasl2-dev libssl-dev libreadline-dev git unzip wget; \
    apt-cleanup; \
    mkdir -p /tmp/luarocks; \
    wget -qO /tmp/luarocks.tar.gz "https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"; \
    tar -xzf /tmp/luarocks.tar.gz --strip-components 1 -C /tmp/luarocks; \
    (cd /tmp/luarocks/ && ./configure && make && make install); \
    rm -rf /tmp/luarocks*; \
    luarocks install cyrussasl 1.1.0-1; \
    luarocks install net-url 0.9-1; \
    luarocks install luajwtjitsi 2.0-0;

FROM ${JITSI_REPO}/base:${BASE_TAG}

LABEL org.opencontainers.image.title="Prosody IM"
LABEL org.opencontainers.image.description="XMPP server used for signalling."
LABEL org.opencontainers.image.url="https://prosody.im/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV XMPP_CROSS_DOMAIN="false"

# confirm gpg key and setup prosody repos
ARG PROSODY_GPG_KEY_URL="https://prosody.im/files/prosody-debian-packages.key"
ARG PROSODY_GPG_FINGERPRINT="107D65A0A148C237FDF00AB47393D7E674D9DBB5"
RUN set -eux; \
    wget -qO /tmp/prosody-debian-packages.key "${PROSODY_GPG_KEY_URL}"; \
    gpg --import /tmp/prosody-debian-packages.key; \
    rm /tmp/prosody-debian-packages.key; \
    gpg --export "${PROSODY_GPG_FINGERPRINT}" > /etc/apt/trusted.gpg.d/prosody.gpg; \
    echo "deb http://packages.prosody.im/debian bullseye main" > /etc/apt/sources.list.d/prosody.list; \
    apt-dpkg-wrap apt-get update; \
    apt-dpkg-wrap apt-get upgrade -y; \
    apt-cleanup;

# install prosody
ARG VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN=1.7.0
RUN set -eux; \
    apt-dpkg-wrap apt-get update; \
    apt-dpkg-wrap apt-get install -y prosody-0.11 libssl1.1 libldap-common sasl2-bin libsasl2-modules-ldap lua-basexx lua-ldap lua-sec patch; \
    apt-dpkg-wrap apt-mark hold prosody; \
    rm -rf /etc/prosody; \
    apt-dpkg-wrap apt-get -d install -y jitsi-meet-prosody; \
    dpkg -x /var/cache/apt/archives/jitsi-meet-prosody*.deb /tmp/pkg; \
    mv /tmp/pkg/usr/share/jitsi-meet/prosody-plugins /prosody-plugins; \
    apt-cleanup; \
    rm -rf /tmp/pkg; \
    mkdir -p /tmp/prosody-mod; \
    wget -qO /tmp/prosody-mod.tar.gz "https://github.com/matrix-org/prosody-mod-auth-matrix-user-verification/archive/refs/tags/v${VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN}.tar.gz"; \
    tar -xzf /tmp/prosody-mod.tar.gz --strip-components 1 -C /tmp/prosody-mod; \
    (cd /tmp/prosody-mod/ && mv ./mod_auth_matrix_user_verification.lua ./mod_matrix_power_sync.lua /prosody-plugins/); \
    rm -rf /tmp/prosody-mod*;

# overlay lua files from builder
COPY --from=builder /usr/local/lib/lua /usr/local/lib/lua
COPY --from=builder /usr/local/share/lua /usr/local/share/lua

# overlay our base rootfs
COPY rootfs/ /

EXPOSE 5222 5347 5280

VOLUME ["/config", "/prosody-plugins-custom"]
