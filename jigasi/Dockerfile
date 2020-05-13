ARG JITSI_REPO=jitsi
ARG JITSI_BUILD=latest
FROM ${JITSI_REPO}/base-java:${JITSI_BUILD}

ENV GOOGLE_APPLICATION_CREDENTIALS /config/key.json

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jigasi jq && \
	apt-cleanup

COPY rootfs/ /

VOLUME ["/config", "/tmp/transcripts"]
