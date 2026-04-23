ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Gateway to SIP (jigasi)"
LABEL org.opencontainers.image.description="Server-side application that allows regular SIP clients to join conferences."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jigasi"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

ENV GOOGLE_APPLICATION_CREDENTIALS=/config/key.json

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jigasi jq jitsi-autoscaler-sidecar && \
    apt-cleanup

# The jigasi package ships the Sentry core JAR but not the JUL handler needed for logging integration.
RUN SENTRY_VERSION=$(basename /usr/share/jigasi/lib/sentry-[0-9]*.jar | grep -oP '\d+\.\d+\.\d+') && \
    curl -sfL "https://repo1.maven.org/maven2/io/sentry/sentry-jul/${SENTRY_VERSION}/sentry-jul-${SENTRY_VERSION}.jar" \
        -o "/usr/share/jigasi/lib/sentry-jul-${SENTRY_VERSION}.jar"

COPY rootfs/ /

VOLUME ["/config", "/tmp/transcripts"]
