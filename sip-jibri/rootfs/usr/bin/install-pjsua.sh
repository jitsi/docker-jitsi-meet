#!/bin/bash

set -o pipefail -xeu

mv /opt/jitsi/jibri/pjsua.custom.sh /opt/jitsi/jibri/pjsua.sh
mv /opt/jitsi/jibri/finalize_sip.custom.sh /opt/jitsi/jibri/finalize_sip.sh
mv /etc/jitsi/jibri/pjsua.custom.config /etc/jitsi/jibri/pjsua.config

chmod 755 /usr/local/bin/pjsua

pjsua --version
