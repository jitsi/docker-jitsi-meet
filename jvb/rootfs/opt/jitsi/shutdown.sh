#!/usr/bin/with-contenv bash
# notify the sidecar of imminent shutdown
[ -z "$AUTOSCALER_SIDECAR_PORT" ] && export AUTOSCALER_SIDECAR_PORT="6000"
curl -d '{}' -v 0:$AUTOSCALER_SIDECAR_PORT/hook/v1/shutdown
sleep 10

# shutdown everything
s6-svscanctl -t /var/run/s6/services
