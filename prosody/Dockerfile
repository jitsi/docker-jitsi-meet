ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest

FROM ${JITSI_REPO}/base:${BASE_TAG} as builder

RUN \
    apt-dpkg-wrap apt-get update \
    && apt-dpkg-wrap apt-get install -y \
      lua5.2 \
      liblua5.2-dev \
      libsasl2-dev \
      libssl-dev \
      luarocks \
      git \
      gcc \
    && luarocks install cyrussasl 1.1.0-1 \
    && luarocks install net-url 0.9-1 \
    && luarocks install luajwtjitsi 2.0-0

FROM ${JITSI_REPO}/base:${BASE_TAG}

ENV XMPP_CROSS_DOMAIN="false"

ARG PROSODY_PLUGINS_FOLDER="/prosody-plugins"
ARG VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN="1.7.0"

RUN \
    wget -q https://prosody.im/files/prosody-debian-packages.key -O - | gpg --enarmor > /etc/apt/trusted.gpg.d/prosody.asc \
    && echo "deb http://packages.prosody.im/debian buster main" > /etc/apt/sources.list.d/prosody.list \
    && apt-dpkg-wrap apt-get update \
    && apt-dpkg-wrap apt-get install -y \
      prosody \
      libssl1.1 \
      sasl2-bin \
      libsasl2-modules-ldap \
      lua-basexx \
      lua-ldap \
      lua-sec \
      patch \
    && apt-cleanup \
    && rm -rf /etc/prosody

RUN \
    apt-dpkg-wrap apt-get update \
    && apt-dpkg-wrap apt-get -d install -y jitsi-meet-prosody \
    && dpkg -x /var/cache/apt/archives/jitsi-meet-prosody*.deb /tmp/pkg \
    && mv /tmp/pkg/usr/share/jitsi-meet/prosody-plugins $PROSODY_PLUGINS_FOLDER \
    && apt-cleanup \
    && rm -rf /tmp/pkg /var/cache/apt

RUN patch -d /usr/lib/prosody/modules/muc -p0 < $PROSODY_PLUGINS_FOLDER/muc_owner_allow_kick.patch

RUN wget https://github.com/matrix-org/prosody-mod-auth-matrix-user-verification/archive/refs/tags/v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz \
    && tar -xf v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz \
    && mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_auth_matrix_user_verification.lua $PROSODY_PLUGINS_FOLDER \
    && mv prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN/mod_matrix_power_sync.lua $PROSODY_PLUGINS_FOLDER \
    && rm -rf prosody-mod-auth-matrix-user-verification-$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN v$VERSION_MATRIX_USER_VERIFICATION_SERVICE_PLUGIN.tar.gz

COPY rootfs/ /

COPY --from=builder /usr/local/lib/lua /usr/local/lib/lua
COPY --from=builder /usr/local/share/lua /usr/local/share/lua

EXPOSE 5222 5347 5280

VOLUME ["/config", "/prosody-plugins-custom"]
