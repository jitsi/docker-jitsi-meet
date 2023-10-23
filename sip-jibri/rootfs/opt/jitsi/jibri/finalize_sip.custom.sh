#!/bin/bash

LOG_DIR_PATH="/config/logs"
LATEST_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua.log"
AGGREGATED_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua_all.log"

pkill -f "ffmpeg .* /dev/video0"
pkill -f "ffmpeg .* /dev/video1"

i=0
while pkill -f "ffmpeg .* /dev/video"; do
  (( i = i + 1))

  if [[ $i -gt 10 ]]; then 
    pkill --signal SIGKILL -f "ffmpeg .* /dev/video"
    break
  fi

  sleep 1
done

if [[ -f "$LATEST_PJSUA_LOG_FILE" ]]; then
  echo "Appending pjsua logs from $LATEST_PJSUA_LOG_FILE, to $AGGREGATED_PJSUA_LOG_FILE"
  cat "$LATEST_PJSUA_LOG_FILE" >> "$AGGREGATED_PJSUA_LOG_FILE"
fi
