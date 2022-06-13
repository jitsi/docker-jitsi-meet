ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest

FROM ${JITSI_REPO}/base:${BASE_TAG} as builder

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
      build-essential \
      lua5.4 \
      liblua5.4-dev \
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
    luarocks install luajwtjitsi 3.0-0

FROM ${JITSI_REPO}/base:${BASE_TAG}

LABEL org.opencontainers.image.title="Prosody IM"
LABEL org.opencontainers.image.description="XMPP server used for signalling."
LABEL org.opencontainers.image.url="https://prosody.im/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ARG VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN="1.7.0"

RUN wget -qO /etc/apt/trusted.gpg.d/prosody.gpg https://prosody.im/files/prosody-debian-packages.key && \
    echo "deb http://packages.prosody.im/debian bullseye main" > /etc/apt/sources.list.d/prosody.list && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
      lua5.4 \
      prosody \
      libssl1.1 \
      libldap-common \
      sasl2-bin \
      libsasl2-modules-ldap \
      lua-basexx \
      lua-ldap \
      lua-sec \
      lua-unbound && \
    apt-dpkg-wrap apt-get -d install -y jitsi-meet-prosody && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-prosody*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet/prosody-plugins /prosody-plugins && \
    rm -f /prosody-plugins/token/util.lib.lua && \
    wget -qO /prosody-plugins/token/util.lib.lua https://raw.githubusercontent.com/jitsi/jitsi-meet/46dd88c91b63988f516114daee65ff8995c74c56/resources/prosody-plugins/token/util.lib.lua && \
    wget -qO /prosody-plugins/mod_auth_cyrus.lua https://hg.prosody.im/prosody-modules/raw-file/65438e4ba563/mod_auth_cyrus/mod_auth_cyrus.lua && \
    wget -qO /prosody-plugins/sasl_cyrus.lua https://hg.prosody.im/prosody-modules/raw-file/65438e4ba563/mod_auth_cyrus/sasl_cyrus.lua  && \
    apt-cleanup && \
    rm -rf /tmp/pkg /var/cache/apt && \
    rm -rf /etc/prosody && \
    wget https://github.com/matrix-org/prosody-mod-auth-matrix-user-verification/archive/refs/tags/v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz && \
    tar -xf v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz && \
    mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_auth_matrix_user_verification.lua /prosody-plugins && \
    mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_matrix_power_sync.lua /prosody-plugins && \
    rm -rf prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz

COPY rootfs/ /

COPY --from=builder /usr/local/lib/lua /usr/local/lib/lua
COPY --from=builder /usr/local/share/lua /usr/local/share/lua

EXPOSE 5222 5280

VOLUME ["/config", "/prosody-plugins-custom"]
