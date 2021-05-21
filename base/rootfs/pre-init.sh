#!/bin/sh

# set user for s6
sed -i "s/\${3}/$(id -u)/g" /usr/bin/fix-attrs

# workaround around mounts taking too much time
while ! mkdir -p /run/s6; do sleep 1; done

# set username
if ! whoami > /dev/null 2>&1; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

exec /init
