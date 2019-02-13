FROM jitsi/base

ADD https://raw.githubusercontent.com/jitsi/jitsi-meet/fc129d9849ca5e26245d54df6451931b6c179987/resources/prosody-plugins/token/util.lib.lua /prosody-plugins/token/util.lib.lua
ADD https://raw.githubusercontent.com/jitsi/jitsi-meet/fc129d9849ca5e26245d54df6451931b6c179987/resources/prosody-plugins/mod_token_verification.lua /prosody-plugins/mod_token_verification.lua
ADD https://raw.githubusercontent.com/jitsi/jitsi-meet/fc129d9849ca5e26245d54df6451931b6c179987/resources/prosody-plugins/mod_auth_token.lua /prosody-plugins/mod_auth_token.lua

RUN sed -i s/hook/hook_global/g /prosody-plugins/mod_auth_token.lua

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y lua5.2 liblua5.2-dev libssl1.0-dev lua-basexx luarocks gcc git && \
	apt-dpkg-wrap apt-get install -t stretch-backports -y prosody && \
	rm -rf /etc/prosody

RUN \
	luarocks install lua-cjson 2.1.0-1 && \
	luarocks install luajwtjitsi

RUN \
	apt-dpkg-wrap apt-get remove -y liblua5.2-dev libssl1.0-dev gcc git && \
	apt-cleanup

COPY rootfs/ /

EXPOSE 5222 5269 5347 5280

VOLUME ["/config", "/prosody-plugins-custom"]
