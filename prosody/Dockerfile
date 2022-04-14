ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest

FROM ${JITSI_REPO}/base:${BASE_TAG} as builder

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
      build-essential \
      lua5.2 \
      liblua5.2-dev \
      libsasl2-dev \
      libssl-dev \
      libreadline-dev \
      git \
      unzip \
      wget && \
    mkdir /tmp/luarocks && \
    wget -qO - https://luarocks.github.io/luarocks/releases/luarocks-3.8.0.tar.gz | tar xfz - --strip-components 1 -C /tmp/luarocks && \
    cd /tmp/luarocks && ./configure && make && make install && cd - && \
    luarocks install cyrussasl 1.1.0-1 && \
    luarocks install net-url 0.9-1 && \
    luarocks install luajwtjitsi 2.0-0

FROM ${JITSI_REPO}/base:${BASE_TAG}

LABEL org.opencontainers.image.title="Prosody IM"
LABEL org.opencontainers.image.description="XMPP server used for signalling."
LABEL org.opencontainers.image.url="https://prosody.im/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV XMPP_CROSS_DOMAIN="false"

ARG VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN="1.7.0"

RUN wget -qO /etc/apt/trusted.gpg.d/prosody.gpg https://prosody.im/files/prosody-debian-packages.key && \
    echo "deb http://packages.prosody.im/debian bullseye main" > /etc/apt/sources.list.d/prosody.list && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
      prosody-0.11 \
      libssl1.1 \
      libldap-common \
      sasl2-bin \
      libsasl2-modules-ldap \
      lua-basexx \
      lua-ldap \
      lua-sec \
      patch && \
    apt-cleanup && \
    rm -rf /etc/prosody && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get -d install -y jitsi-meet-prosody && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-prosody*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet/prosody-plugins /prosody-plugins && \
    apt-cleanup && \
    rm -rf /tmp/pkg /var/cache/apt && \
    patch -d /usr/lib/prosody/modules/muc -p0 < /prosody-plugins/muc_owner_allow_kick.patch && \
    wget https://github.com/matrix-org/prosody-mod-auth-matrix-user-verification/archive/refs/tags/v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz && \
    tar -xf v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz && \
    mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_auth_matrix_user_verification.lua /prosody-plugins && \
    mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_matrix_power_sync.lua /prosody-plugins && \
    rm -rf prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz

COPY rootfs/ /

COPY --from=builder /usr/local/lib/lua /usr/local/lib/lua
COPY --from=builder /usr/local/share/lua /usr/local/share/lua

EXPOSE 5222 5347 5280

VOLUME ["/config", "/prosody-plugins-custom"]
