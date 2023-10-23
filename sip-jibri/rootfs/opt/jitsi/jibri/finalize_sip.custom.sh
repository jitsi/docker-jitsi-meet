#!/bin/bash

LOG_DIR_PATH="/config/logs"
LATEST_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua.log"
AGGREGATED_PJSUA_LOG_FILE="$LOG_DIR_PATH/pjsua_all.log"

if [[ -f "$LATEST_PJSUA_LOG_FILE" ]]; then
  echo "Appending pjsua logs from $LATEST_PJSUA_LOG_FILE, to $AGGREGATED_PJSUA_LOG_FILE"
  cat "$LATEST_PJSUA_LOG_FILE" >> "$AGGREGATED_PJSUA_LOG_FILE"
fi
