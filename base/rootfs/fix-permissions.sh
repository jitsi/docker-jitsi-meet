#!/bin/bash

chown 1001:0 -R /config /var/log /var/lib
chmod g=u -R /config /var/log /var/lib /etc/localtime /etc/timezone /etc/s6 /etc/passwd /run /root /usr/bin

# File should delete itself
rm -- "$0"
