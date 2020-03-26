#!/bin/bash

echo "Building custom jitsi/web"
cd web
docker build --tag jitsi/web:custom .
cd ..
