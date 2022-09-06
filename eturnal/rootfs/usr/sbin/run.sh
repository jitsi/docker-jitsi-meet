#!/bin/sh
# eturnal config
#DOCKER_INTERNAL_IP=$(cat /etc/hosts | grep $(hostname) |  awk '{ print $1 }')
cat > /opt/eturnal/etc/eturnal.yml <<EOF
eturnal:
  listen:
    -
      ip: "::"
      port: 3478
      transport: auto
      proxy_protocol: true

  ## Reject TURN relaying from/to the following addresses/networks:
  blacklist:                # This is the default blacklist.
    - "127.0.0.0/8"         # IPv4 loopback.
    - "::1"                 # IPv6 loopback.
    - recommended           # Expands to a number of networks recommended to be
                            # blocked, but includes private networks. Those
                            # would have to be 'whitelist'ed if eturnal serves
                            # local clients/peers within such networks.

  ## Logging configuration:
  log_level: info           # critical | error | warning | notice | info | debug
  log_dir: stdout          # Enable for logging to the terminal/journal.

  ## See: https://eturnal.net/documentation/#Module_Configuration
  modules:
    mod_log_stun: {}        # Log STUN queries (in addition to TURN sessions).
    #mod_stats_influx: {}   # Log STUN/TURN events into InfluxDB.
    #mod_stats_prometheus:  # Expose STUN/TURN and VM metrics to Prometheus.
    #  ip: any              # This is the default: Listen on all interfaces.
    #  port: 8081           # This is the default.
    #  tls: false           # This is the default.
    #  vm_metrics: true     # This is the default.
EOF

# TURN credentials
if [ ! -z $TURN_CREDENTIALS ]
then
export ETURNAL_SECRET=$TURN_CREDENTIALS
fi

# TURN relay port range
if [ ! -z $TURN_RELAY_MIN_PORT ] || [ ! -z $TURN_RELAY_MAX_PORT ] 
then
  if [ ${TURN_RELAY_MIN_PORT-50000} \< ${TURN_RELAY_MAX_PORT-50500} ]
  then
    export ETURNAL_RELAY_MIN_PORT=${TURN_RELAY_MIN_PORT-50000}
    export ETURNAL_RELAY_MAX_PORT=${TURN_RELAY_MAX_PORT-50500}
  else
    echo ""
    echo " Configuration check:"
    echo ""
    echo " [WARNING] Defined TURN range minimum port -> ${TURN_RELAY_MIN_PORT-50000} is greater or equal than maximum port -> ${TURN_RELAY_MAX_PORT-50500}"
    echo " [INFO] Starting eturnal with relay port range 50000 - 50500"
    echo ""
    export ETURNAL_RELAY_MIN_PORT=50000
    export ETURNAL_RELAY_MAX_PORT=50500
  fi
else
  export ETURNAL_RELAY_MIN_PORT=50000
  export ETURNAL_RELAY_MAX_PORT=50500 
fi

# discover public IP addresses
if [ ! -z $DOCKER_HOST_ADDRESS ]
then
  export ETURNAL_RELAY_IPV4_ADDR=$DOCKER_HOST_ADDRESS
else 
  if [ -z "$JVB_DISABLE_STUN" ]
  then
    export ETURNAL_RELAY_IPV4_ADDR=${ETURNAL_RELAY_IPV4_ADDR-$(stun -4 $STUN_SERVICE)}
  fi
fi
exec "$@"