#!/bin/bash

LOG_DIR_PATH="/config/logs"
LATEST_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua.log"
AGGREGATED_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua_all.log"

pkill --signal SIGINT -f "ffmpeg .* /dev/video0"
pkill --signal SIGINT -f "ffmpeg .* /dev/video1"

while pgrep -f "ffmpeg .* /dev/video[01]"; do
  sleep 1
done

if [[ -f "$LATEST_PJSUA_LOG_FILE" ]]; then
  echo "Appending pjsua logs from $LATEST_PJSUA_LOG_FILE, to $AGGREGATED_PJSUA_LOG_FILE"
  cat "$LATEST_PJSUA_LOG_FILE" >> "$AGGREGATED_PJSUA_LOG_FILE"
fi
