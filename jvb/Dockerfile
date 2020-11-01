ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base-java

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jitsi-videobridge2 jq curl iproute2 && \
	apt-cleanup

COPY rootfs/ /

# https://github.com/jitsi/docker-jitsi-meet/issues/207
ADD http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb /ssl.deb
RUN apt-dpkg-wrap dpkg -i /ssl.deb && rm -f /ssl.deb
   
VOLUME /config
