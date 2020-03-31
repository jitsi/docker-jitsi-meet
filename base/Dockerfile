FROM debian:stretch-slim

ARG JITSI_RELEASE=stable

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
ADD https://download.jitsi.org/jitsi-key.gpg.key /tmp/jitsi.key
ADD https://github.com/subchen/frep/releases/download/v1.3.5/frep-1.3.5-linux-amd64 /usr/bin/frep

COPY rootfs /

RUN \
	tar xfz /tmp/s6-overlay.tar.gz -C / && \
	rm -f /tmp/*.tar.gz && \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y apt-transport-https apt-utils ca-certificates gnupg && \
	apt-key add /tmp/jitsi.key && \
	rm -f /tmp/jitsi.key && \
	echo "deb https://download.jitsi.org $JITSI_RELEASE/" > /etc/apt/sources.list.d/jitsi.list && \
	echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list && \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get dist-upgrade -y && \
	apt-cleanup && \
	chmod +x /usr/bin/frep

RUN \
	[ "$JITSI_RELEASE" = "unstable" ] && \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jq procps curl vim iputils-ping net-tools && \
	apt-cleanup || \
	true

ENTRYPOINT [ "/init" ]
