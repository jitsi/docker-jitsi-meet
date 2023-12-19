#!/usr/bin/with-contenv bash

# shutdown everything
s6-svscanctl -t /var/run/s6/services
