ARG JITSI_REPO=jitsi
ARG JITSI_BUILD=latest
FROM ${JITSI_REPO}/base:${JITSI_BUILD}

RUN	\
	mkdir -p /usr/share/man/man1 && \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y openjdk-8-jre-headless && \
	apt-cleanup

