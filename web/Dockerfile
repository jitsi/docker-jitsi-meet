ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base

ADD https://dl.eff.org/certbot-auto /usr/local/bin/

COPY rootfs/ /

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y cron nginx-extras jitsi-meet-web && \
	apt-dpkg-wrap apt-get -d install -y jitsi-meet-web-config && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults && \
	mv /usr/share/jitsi-meet/interface_config.js /defaults && \
	apt-cleanup && \
	rm -f /etc/nginx/conf.d/default.conf && \
	rm -rf /tmp/pkg /var/cache/apt
	# Customizations
	rm -f /usr/share/jitsi-meet/title.html && \
	rm -f /usr/share/jitsi-meet/favicon.ico && \
	rm -f /usr/share/jitsi-meet/images/favicon.ico && \
	rm -f /usr/share/jitsi-meet/images/watermark.png && \
	rm -f /usr/share/jitsi-meet/css/_welcome_page.scss && \
	rm -f /usr/share/jitsi-meet/react/features/deep-linking/components/DeepLinkingMobilePage.web.js && \
	rm -f /usr/share/jitsi-meet/react/features/recording/components/Recording/styles.native.js && \
	rm -f /usr/share/jitsi-meet/react/features/recording/components/Recording/styles.web.js && \
	rm -f /usr/share/jitsi-meet/react/features/welcome/components/WelcomePage.web.js

RUN \
	chmod a+x /usr/local/bin/certbot-auto && \
	certbot-auto --noninteractive --install-only

EXPOSE 80 443

VOLUME ["/config", "/etc/letsencrypt", "/usr/share/jitsi-meet/transcripts"]
