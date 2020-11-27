ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base

ADD https://dl.eff.org/certbot-auto /usr/local/bin/

COPY rootfs/ /

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y cron nginx-extras jitsi-meet-web python3-venv && \
	apt-dpkg-wrap apt-get -d install -y jitsi-meet-web-config && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults && \
	mv /usr/share/jitsi-meet/interface_config.js /defaults && \
	rm -f /etc/nginx/conf.d/default.conf && \
	apt-cleanup && \
	rm -rf /tmp/pkg /var/cache/apt

RUN \
	chmod a+x /usr/local/bin/certbot-auto && \
	USE_PYTHON_3=1 certbot-auto --noninteractive --install-only --no-bootstrap

EXPOSE 80 443

VOLUME ["/config", "/etc/letsencrypt", "/usr/share/jitsi-meet/transcripts"]
