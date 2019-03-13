FROM jitsi/base

ADD https://raw.githubusercontent.com/jitsi/jitsi-meet/fc129d9849ca5e26245d54df6451931b6c179987/resources/prosody-plugins/token/util.lib.lua /prosody-plugins/token/util.lib.lua
ADD https://raw.githubusercontent.com/jitsi/jitsi-meet/fc129d9849ca5e26245d54df6451931b6c179987/resources/prosody-plugins/mod_token_verification.lua /prosody-plugins/mod_token_verification.lua
ADD https://raw.githubusercontent.com/jitsi/jitsi-meet/fc129d9849ca5e26245d54df6451931b6c179987/resources/prosody-plugins/mod_auth_token.lua /prosody-plugins/mod_auth_token.lua

RUN sed -i s/hook/hook_global/g /prosody-plugins/mod_auth_token.lua

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
    && rm -rf /etc/prosody

COPY rootfs/ /

EXPOSE 5222 5269 5347 5280

VOLUME ["/config", "/prosody-plugins-custom"]
