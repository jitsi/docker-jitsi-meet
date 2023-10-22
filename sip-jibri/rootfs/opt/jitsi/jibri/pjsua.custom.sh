#!/bin/bash
set -e

# push display :0 view to virtual-camera-1
ffmpeg -f x11grab -r 30 -i :0.0 -pix_fmt yuv420p -f v4l2 /dev/video1 &
sleep 0.8

REGISTRAR=$(echo "$@" | egrep -o "..registrar=sip:[^ ]" || true)
AUTO_ANSWER=$(echo "$@" | egrep -o "..auto-answer-timer=[0-9]+" || true)

# if auto-answer is set but there is no registrar, then this should be a direct
# incoming call. Use the customized command in this case.
if [[ -z "$REGISTRAR" && -n "$AUTO_ANSWER" ]]; then
    TIMER=$(echo $AUTO_ANSWER | cut -d '=' -f2)

    exec /usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config \
        --auto-answer-timer=$TIMER --auto-answer=200 >/dev/null
else
    exec /usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config \
        "$@" >/dev/null
fi
