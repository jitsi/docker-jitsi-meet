ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base-java

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jitsi-videobridge2 jq curl iproute2 && \
	apt-cleanup

COPY rootfs/ /

# https://github.com/jitsi/docker-jitsi-meet/issues/207
RUN \
   apt-dpkg-wrap apt-get update && \
   apt-dpkg-wrap apt-get install -y wget && \
  	apt-cleanup && \
   wget -O /ssl.deb http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb && \
   apt-dpkg-wrap dpkg -i /ssl.deb && \
   rm /ssl.deb -f

VOLUME /config
