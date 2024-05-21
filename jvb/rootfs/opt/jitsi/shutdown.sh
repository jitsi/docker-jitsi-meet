#!/usr/bin/with-contenv bash
# notify the sidecar of imminent shutdown
PORT=${AUTOSCALER_SIDECAR_PORT:-6000}
curl -d '{}' -v 0:$PORT/hook/v1/shutdown
sleep 10

# shutdown everything
s6-svscanctl -t /var/run/s6/services
