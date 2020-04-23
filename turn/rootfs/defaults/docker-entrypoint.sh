#!/bin/ash

# make certs if not exist
if [[ ! -f /config/cert.crt || ! -f /config/cert.key  ]]; then
  openssl req -newkey rsa:2048 -nodes -keyout /config/cert.key -x509 -days 3650 -out /config/cert.crt -subj "/C=US/ST=NY/L=NY/O=IT/CN=${TURN_HOST}"
fi

# use non empty TURN_PUBLIC_IP variable, othervise set it dynamically.
[ -z "${TURN_PUBLIC_IP}" ] && export TURN_PUBLIC_IP=$(curl -4ks https://icanhazip.com)
[ -z "${TURN_PUBLIC_IP}" ] && echo "ERROR: variable TURN_PUBLIC_IP is not set and can not be set dynamically!" && kill 1

# set coturn web-admin access
if [[ "${TURN_ADMIN_ENABLE}" == "1" || "${TURN_ADMIN_ENABLE}" == "true" ]]; then
  turnadmin -A -u ${TURN_ADMIN_USER:-admin} -p ${TURN_ADMIN_SECRET:-changeme}
  export TURN_ADMIN_OPTIONS="--web-admin --web-admin-ip=$(hostname -i) --web-admin-port=${TURN_ADMIN_PORT:-8443}"
fi

# run coturn server with API auth method enabled.
turnserver -n ${TURN_ADMIN_OPTIONS} \
--verbose \
--prod \
--no-tlsv1 \
--no-tlsv1_1 \
--log-file=stdout \
--listening-port=${TURN_PORT:-5349} \
--tls-listening-port=${TURN_PORT:-5349} \
--alt-listening-port=${TURN_PORT:-5349} \
--alt-tls-listening-port=${TURN_PORT:-5349} \
--cert=/config/cert.crt \
--pkey=/config/cert.key \
--min-port=${TURN_RTP_MIN:-10000} \
--max-port=${TURN_RTP_MAX:-11000} \
--no-stun \
--use-auth-secret \
--static-auth-secret=${TURN_SECRET:-keepthissecret} \
--no-multicast-peers \
--realm=${TURN_REALM:-realm} \
--listening-ip=$(hostname -i) \
--external-ip=${TURN_PUBLIC_IP} \
--cli-password=NotReallyCliUs3d \
--no-cli

