#!/bin/bash

LOG_DIR_PATH="/var/log/jitsi/jibri"
LATEST_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua.log"
AGGREGATED_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua_all.log"

pkill -f "ffmpeg .* /dev/video0"
pkill -f "ffmpeg .* /dev/video1"

if [[ -f "$LATEST_PJSUA_LOG_FILE" ]]; then
  echo "Appending pjsua logs from $LATEST_PJSUA_LOG_FILE, to $AGGREGATED_PJSUA_LOG_FILE"
  cat "$LATEST_PJSUA_LOG_FILE" >> "$AGGREGATED_PJSUA_LOG_FILE"
fi
