FROM jitsi/base

RUN \
	echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list && \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -t stretch-backports -y prosody && \
	apt-cleanup && \
	rm -rf /etc/prosody

COPY rootfs/ /

EXPOSE 5222 5269 5347 5280

VOLUME /config

