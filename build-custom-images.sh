#!/bin/bash

echo "Building custom jitsi/web"
cd web
docker build --tag jitsi/web:custom .
cd ..

envFile=".env"

if [ -f $envFile ]; then
  set -a
  source $envFile

  if [ -d "$CONFIG" ]; then
    if [ ! -d "$CONFIG/prosody-plugins-custom" ]; then
      mkdir "$CONFIG/prosody-plugins-custom"
    fi
    if [ ! -f "$CONFIG/prosody-plugins-custom/mod_token_moderation.lua" ]; then
      cp custom/prosody-plugins-custom/mod_token_moderation.lua "$CONFIG/prosody-plugins-custom/"
    fi
  fi

  set +a
else
  echo "No $envFile file found" 1>&2
  return 1
fi
