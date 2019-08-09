FROM jitsi/base

RUN \
    apt-dpkg-wrap apt-get update \
    && apt-dpkg-wrap apt-get install -t stretch-backports -y \
      prosody \
      liblua5.2-dev \
      sasl2-bin \
      libsasl2-modules-ldap \
      libsasl2-dev \
      libssl1.0-dev \
      lua-basexx \
      lua-ldap \
      luarocks \
      git \
      gcc \
      patch \
    && luarocks install cyrussasl 1.1.0-1 \
    && luarocks install lua-cjson 2.1.0-1 \
    && luarocks install luajwtjitsi 1.3-7 \
    && apt-dpkg-wrap apt-get remove -t stretch-backports -y \
      git \
      gcc \
      luarocks \
      libsasl2-dev \
      libssl1.0-dev \
      liblua5.2-dev \
    && apt-cleanup \
    && rm -rf /etc/prosody /var/cache/apt

RUN \
    apt-dpkg-wrap apt-get update \
    && apt-dpkg-wrap apt-get -d install -y jitsi-meet-tokens \
    && dpkg -x /var/cache/apt/archives/jitsi-meet-tokens*.deb /tmp \
    && mv /tmp/usr/share/jitsi-meet/prosody-plugins /prosody-plugins \
    && apt-cleanup \
    && rm -rf /tmp/usr /var/cache/apt

RUN \
    sed -i s/hook/hook_global/g /prosody-plugins/mod_auth_token.lua \
    && patch -d /usr/lib/prosody/modules/muc -p0 < /prosody-plugins/muc_owner_allow_kick.patch

COPY rootfs/ /

EXPOSE 5222 5269 5347 5280

VOLUME ["/config", "/prosody-plugins-custom"]
