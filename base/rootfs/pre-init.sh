#!/bin/sh

# Set user for s6
sed -i "s/\${3}/$(id -u)/g" /usr/bin/fix-attrs

# workaround around mounts taking too much time
while ! mkdir -p /run/s6; do sleep 1; done

exec /init
