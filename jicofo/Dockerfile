ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM ${JITSI_REPO}/base-java:${BASE_TAG}

LABEL org.opencontainers.image.title="Jitsi Conference Focus (jicofo)"
LABEL org.opencontainers.image.description="Server-side focus component that manages media sessions and acts as load balancer."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jicofo"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jicofo && \
    apt-cleanup

# The jicofo package ships the Sentry core JAR but not the JUL handler needed for logging integration.
RUN SENTRY_VERSION=$(basename /usr/share/jicofo/lib/sentry-[0-9]*.jar | grep -oP '\d+\.\d+\.\d+') && \
    curl -sfL "https://repo1.maven.org/maven2/io/sentry/sentry-jul/${SENTRY_VERSION}/sentry-jul-${SENTRY_VERSION}.jar" \
        -o "/usr/share/jicofo/lib/sentry-jul-${SENTRY_VERSION}.jar"

COPY rootfs/ /

VOLUME /config
