#!/bin/bash

mkdir -p /config/keys
# make certs if not exist
# generate keys (maybe)
if [[ $DISABLE_HTTPS -ne 1 ]]; then
  if [[ $ENABLE_LETSENCRYPT -eq 1 ]]; then
    if [[ ! -f /etc/letsencrypt/live/$LETSENCRYPT_DOMAIN/fullchain.pem ]]; then
      if ! certbot \
        certonly \
        --no-self-upgrade \
        --noninteractive \
        --standalone \
        --preferred-challenges http \
        -d $LETSENCRYPT_DOMAIN \
        --agree-tos \
        --email $LETSENCRYPT_EMAIL; then

        echo "Failed to obtain a certificate from the Let's Encrypt CA."
        # this tries to get the user's attention and to spare the
        # authority's rate limit:
        sleep 15
        echo "Exiting."
        exit 1
      else
        echo "Let's Encrypt certificate generated."
        cp -f /etc/letsencrypt/live/$LETSENCRYPT_DOMAIN/fullchain.pem /config/keys/cert.crt
        cp -f /etc/letsencrypt/live/$LETSENCRYPT_DOMAIN/privkey.pem /config/keys/cert.key
      fi
    fi

    # setup certbot renewal script
    if [[ ! -f /etc/periodic/weekly/letencrypt-renew ]]; then
      cp /defaults/letsencrypt-renew /etc/periodic/weekly/
    fi
  else
    # use self-signed certs
    if [[ -f /config/keys/cert.key && -f /config/keys/cert.crt ]]; then
      echo "using keys found in /config/keys"
    else
      echo "generating self-signed keys in /config/keys, you can replace these with your own keys if required"
      SUBJECT="/C=US/ST=TX/L=Austin/O=jitsi.org/OU=Jitsi Server/CN=*"
      openssl req -new -x509 -days 3650 -nodes -out /config/keys/cert.crt -keyout /config/keys/cert.key -subj "$SUBJECT"
    fi
  fi
fi

# use non empty TURN_PUBLIC_IP variable, othervise set it dynamically.
[ -z "${TURN_PUBLIC_IP}" ] && export TURN_PUBLIC_IP=$(curl -4ks https://icanhazip.com)
[ -z "${TURN_PUBLIC_IP}" ] && echo "ERROR: variable TURN_PUBLIC_IP is not set and can not be set dynamically!" && kill 1

# set coturn web-admin access
if [[ "${TURN_ADMIN_ENABLE}" == "1" || "${TURN_ADMIN_ENABLE}" == "true" ]]; then
  turnadmin -A -u ${TURN_ADMIN_USER:-admin} -p ${TURN_ADMIN_SECRET:-changeme}
  export TURN_ADMIN_OPTIONS="--web-admin --web-admin-ip=$(hostname -i) --web-admin-port=${TURN_ADMIN_PORT:-8443}"
fi

#run cron
crond

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
  --cert=/config/keys/cert.crt \
  --pkey=/config/keys/cert.key \
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
