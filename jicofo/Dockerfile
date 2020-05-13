ARG JITSI_REPO=jitsi
ARG JITSI_BUILD=latest
FROM ${JITSI_REPO}/base-java:${JITSI_BUILD}

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jicofo && \
	apt-cleanup

COPY rootfs/ /

VOLUME /config

