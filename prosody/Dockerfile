ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest

FROM ${JITSI_REPO}/base:${BASE_TAG} AS builder

USER root

RUN \
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    build-essential \
    liblua5.4-dev \
    libreadline-dev \
    lua5.4 \
    unzip \
    && \
  mkdir /tmp/luarocks && \
  wget -qO - \
    https://luarocks.github.io/luarocks/releases/luarocks-3.8.0.tar.gz | \
    tar xfz - --strip-components 1 -C /tmp/luarocks && \
  cd /tmp/luarocks && ./configure && make && make install && cd - && \
  luarocks install basexx 0.4.1-1 && \
  luarocks install lua-cjson 2.1.0-1 && \
  luarocks install net-url 0.9-1

FROM ${JITSI_REPO}/base:${BASE_TAG}

USER root

LABEL org.opencontainers.image.title="Prosody IM"
LABEL org.opencontainers.image.description="XMPP server used for signalling."
LABEL org.opencontainers.image.url="https://prosody.im/"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ARG VERSION_JITSI_CONTRIB_PROSODY_PLUGINS="20241017"
ARG VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN="1.8.0"

COPY rootfs /

RUN \
  set -x && \
  wget -qO - https://prosody.im/files/prosody-debian-packages.key | \
    gpg --dearmour >/usr/share/keyrings/prosody.gpg && \
\
  apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y \
    libldap-common \
    libsasl2-modules-ldap \
    lua5.4 \
    lua-cyrussasl \
    lua-inspect \
    lua-ldap \
    lua-luaossl \
    lua-sec \
    lua-unbound \
    prosody \
    sasl2-bin \
    && \
  apt-dpkg-wrap apt-get install -y -d \
    jitsi-meet-prosody \
    && \
  dpkg -x /var/cache/apt/archives/jitsi-meet-prosody*.deb /tmp/pkg && \
  rm /tmp/pkg/usr/share/jitsi-meet/prosody-plugins/mod_smacks.lua && \
  mv /tmp/pkg/usr/share/jitsi-meet/prosody-plugins /prosody-plugins && \
  rm -rf /tmp/pkg && \
  apt-cleanup && \
  rm -rf /etc/prosody && \
  mv /usr/share/lua/5.3/inspect.lua /usr/share/lua/5.4/ && \
  rm -rf /usr/lib/lua/{5.1,5.2,5.3} && \
  rm -rf /usr/share/lua/{5.1,5.2,5.3} && \
  wget -qO /prosody-plugins/mod_auth_cyrus.lua https://hg.prosody.im/prosody-modules/raw-file/65438e4ba563/mod_auth_cyrus/mod_auth_cyrus.lua && \
  wget -qO /prosody-plugins/sasl_cyrus.lua https://hg.prosody.im/prosody-modules/raw-file/65438e4ba563/mod_auth_cyrus/sasl_cyrus.lua  && \
  wget -qO /prosody-plugins/mod_http_health.lua https://hg.prosody.im/prosody-modules/raw-file/2b80188448d1/mod_http_health/mod_http_health.lua && \
\
  wget https://github.com/matrix-org/prosody-mod-auth-matrix-user-verification/archive/refs/tags/v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz && \
  tar -xf v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz && \
  mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_auth_matrix_user_verification.lua /prosody-plugins && \
  mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_matrix_power_sync.lua /prosody-plugins && \
  rm -rf prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz && \
\
  wget -q https://github.com/jitsi-contrib/prosody-plugins/archive/refs/tags/v$VERSION_JITSI_CONTRIB_PROSODY_PLUGINS.tar.gz && \
  tar -xf v$VERSION_JITSI_CONTRIB_PROSODY_PLUGINS.tar.gz && \
  mkdir /prosody-plugins-contrib && \
  cp -a prosody-plugins-$VERSION_JITSI_CONTRIB_PROSODY_PLUGINS/*  /prosody-plugins-contrib && \
  rm -rf prosody-plugins-$VERSION_JITSI_CONTRIB_PROSODY_PLUGINS v$VERSION_JITSI_CONTRIB_PROSODY_PLUGINS.tar.gz && \
\
  adduser s6 prosody && \
  adduser s6 sasl && \
  chown s6:sasl /var/run/saslauthd && \
  echo "TLS_REQCERT allow" >>/etc/ldap/ldap.conf

COPY --from=builder /usr/local/lib/lua/5.4 /usr/local/lib/lua/5.4
COPY --from=builder /usr/local/share/lua/5.4 /usr/local/share/lua/5.4

EXPOSE 5222 5280

VOLUME ["/config", "/prosody-plugins-custom"]

USER s6
