ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base-java

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jicofo && \
	apt-cleanup

COPY rootfs/ /
COPY trs-jicofo/jicofo-1.1-SNAPSHOT/ /usr/share/jicofo/

VOLUME /config

