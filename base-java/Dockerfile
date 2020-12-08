ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base

RUN	\
	mkdir -p /usr/share/man/man1 && \
	wget -q https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public -O /etc/apt/trusted.gpg.d/openjdk.asc && \
	echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main" > /etc/apt/sources.list.d/openjdk.list && \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y adoptopenjdk-8-hotspot-jre && \
	apt-cleanup
