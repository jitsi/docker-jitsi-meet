ARG JITSI_REPO=jitsi

FROM node:10-stretch-slim AS builder

ADD https://github.com/jitsi/jitsi-meet-spot/archive/master.tar.gz /tmp/spot.tar.gz
WORKDIR /build

RUN \
    apt update && apt install -y git && \
    tar xvf /tmp/spot.tar.gz --strip 1 && \
    cd spot-client && \
    npm install && \
    npm run build:prod


FROM ${JITSI_REPO}/base

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y nginx && \
	apt-cleanup && \
	rm -f /etc/nginx/conf.d/default.conf

COPY rootfs/ /
COPY --from=builder /build/spot-client/dist /usr/share/spot-client/dist
COPY --from=builder /build/spot-client/index.html /usr/share/spot-client/

EXPOSE 9002

VOLUME ["/config"]
