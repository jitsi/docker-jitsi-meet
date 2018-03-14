FROM jitsi/base

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y nginx-extras jitsi-meet-web && \
	apt-cleanup && \
	rm -f /etc/nginx/conf.d/default.conf

COPY rootfs/ /

EXPOSE 80 443

VOLUME /config

