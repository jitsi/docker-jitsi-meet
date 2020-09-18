#!/bin/bash

# Security
#
# Set these to strong passwords to avoid intruders from impersonating a service account
# The service(s) won't start unless these are specified
# Running ./gen-passwords.sh will update .env with strong passwords
# You may skip the Jigasi and Jibri passwords if you are not using those
# DO NOT reuse passwords
#

function generatePassword() {
    openssl rand -hex 16
}

GENERATED_ENV_VARIABLES=(
    # XMPP component password for Jicofo
    JICOFO_COMPONENT_SECRET

    # XMPP password for Jicofo client connections
    JICOFO_AUTH_PASSWORD

    # XMPP password for JVB client connections
    JVB_AUTH_PASSWORD

    # XMPP password for Jigasi MUC client connections
    JIGASI_XMPP_PASSWORD

    # XMPP recorder password for Jibri client connections
    JIBRI_RECORDER_PASSWORD

    # XMPP password for Jibri client connections
    JIBRI_XMPP_PASSWORD

    # JWT Authentication
    # Application secret known only to your token
    JWT_APP_SECRET
)

for ENV_VARIABLE in "${GENERATED_ENV_VARIABLES[@]}"; do
    if [[ -e ".secrets/${ENV_VARIABLE}.env" ]]; then
	mv ".secrets/${ENV_VARIABLE}.env" ".secrets/${ENV_VARIABLE}.env.bak"
    fi
    echo "${ENV_VARIABLE}=$(generatePassword)" > ".secrets/${ENV_VARIABLE}.env"
done
