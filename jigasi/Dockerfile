ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

ENV RCLONE_VER=v1.59.1 \
    ARCH=amd64 \
    SUBCMD="" \
    CONFIG="--config /usr/src/app/rclone.conf" \
    PARAMS=""
RUN apt-get update    
RUN apt-get -y install curl
RUN apt-get install unzip
RUN curl -O "https://downloads.rclone.org/v1.59.1/rclone-v1.59.1-linux-amd64.zip"
RUN unzip rclone-v1.59.1-linux-amd64.zip
RUN cd rclone-v1.59.1-linux-amd64
RUN cp rclone-v1.59.1-linux-amd64/rclone /usr/bin/
RUN chown root:root /usr/bin/rclone
RUN chmod 755 /usr/bin/rclone
RUN mkdir -p /usr/share/man/man1
RUN cp rclone-v1.59.1-linux-amd64/rclone.1 /usr/share/man/man1/
RUN rm -f rclone-v1.59.1-linux-amd64.zip
RUN rm -r rclone-v1.59.1-linux-amd64
RUN apt-get -y install inotify-tools


LABEL org.opencontainers.image.title="Jitsi Gateway to SIP (jigasi)"
LABEL org.opencontainers.image.description="Server-side application that allows regular SIP clients to join conferences."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jigasi"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV GOOGLE_APPLICATION_CREDENTIALS /config/key.json

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jigasi jq && \
    apt-cleanup

COPY rootfs/ /

VOLUME ["/config", "/tmp/transcripts"]