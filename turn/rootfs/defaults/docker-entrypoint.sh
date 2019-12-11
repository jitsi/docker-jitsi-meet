#!/bin/ash
# make certs if not exist
if [[ ! -f /etc/ssl/cert.crt || ! -f /etc/ssl/cert.key  ]]; then
  openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 3650 -out certificate.pem -subj "/C=US/ST=NY/L=NY/O=IT/CN=${TURN_HOST}"
fi

# set coturn admin user
turnadmin -A -u ${TURN_ADMIN_USER:-admin} -p ${TURN_ADMIN_SECRET:-changeme}

# run coturn server with API auth method enabled.
turnserver -n \
--verbose \
--prod \
--no-tlsv1 \
--no-tlsv1_1 \
--log-file=stdout \
--listening-port=${TURN_PORT:-5349} \
--tls-listening-port=${TURN_PORT:-5349} \
--alt-listening-port=${TURN_PORT:-5349} \
--alt-tls-listening-port=${TURN_PORT:-5349} \
--cert=/etc/ssl/cert.crt \
--pkey=/etc/ssl/cert.key \
--min-port=${TURN_RTP_MIN:-10000} \
--max-port=${TURN_RTP_MAX:-11000} \
--no-stun \
--use-auth-secret \
--static-auth-secret=${TURN_SECRET:-keepthissecret} \
--no-multicast-peers \
--realm=${TURN_REALM:-realm} \
--external-ip=$(curl -4k https://icanhazip.com 2>/dev/null) \
--relay-ip=$(hostname -i) \
--listening-ip=$(hostname -i) \
--web-admin \
--web-admin-ip=$(hostname -i) \
--web-admin-port=${TURN_ADMIN_PORT:-8443} \
--no-cli \
--cli-password=${TURN_ADMIN_SECRET:-changeme}

