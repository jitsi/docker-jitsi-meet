ARG VERSION
FROM instrumentisto/coturn:${VERSION:-latest}

RUN apk add --no-cache openssl

ADD ./rootfs/defaults/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME ["/config"]

EXPOSE 5349 8443 10000:11000/udp

