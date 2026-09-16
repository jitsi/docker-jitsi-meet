#!/command/with-contenv bash

# notify the sidecar of imminent shutdown
PORT=${AUTOSCALER_SIDECAR_PORT:-6000}
curl -d '{}' -v 0:$PORT/hook/v1/shutdown
sleep 10

# signal jibri to shutdown via rest api
/opt/jitsi/jibri/shutdown.sh

# shutdown everything else.
#
# Under s6-overlay v3 this must go through halt: PID 1 is s6-linux-init's wait
# for a halt/poweroff/reboot event, and only halt wakes it. The v2 idiom
# `s6-svscanctl -t /run/service` stops s6-svscan and every s6-supervise but
# leaves PID 1 running, so the container never exits and the services it was
# supervising keep running, orphaned to PID 1.
/run/s6/basedir/bin/halt
