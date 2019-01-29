FROM jitsi/base-java

ARG JITSI_RELEASE=unstable

RUN \
	apt-dpkg-wrap apt-get update \
	&& apt-dpkg-wrap apt-get install -y curl gnupg \
	&& curl -4s https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& echo "deb https://download.jitsi.org $JITSI_RELEASE/" > /etc/apt/sources.list.d/jitsi.list \
	&& apt-dpkg-wrap apt-get update \
	&& apt-dpkg-wrap apt-get install -y jibri google-chrome-stable vim procps \
	&& apt-dpkg-wrap apt-get autoremove -y --purge gnupg \
	&& apt-cleanup \
	&& curl -4Ls https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip | zcat >> /usr/bin/chromedriver \
        && chmod +x /usr/bin/chromedriver

COPY rootfs/ /

VOLUME /config

