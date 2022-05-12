#!/usr/bin/env bash

function generatePassword() {
    openssl rand -hex 16
}

function generateSecrets() {
    local -r secrets_dir="${0%/*}/.secrets"
    local -ar secrets=(
        "CALLSTATS_SECRET"
        "JIBRI_RECORDER_PASSWORD"
        "JIBRI_XMPP_PASSWORD"
        "JICOFO_AUTH_PASSWORD"
        "JICOFO_COMPONENT_SECRET"
        "JIGASI_XMPP_PASSWORD"
        "JVB_AUTH_PASSWORD"
        "JWT_APP_SECRET"
    )

    [[ -d "${secrets_dir}" ]] || mkdir -p "${secrets_dir}"

    for name in "${secrets[@]}"; do
        # skip if exists.
        ! [[ -f "${secrets_dir}/${name}" ]] || continue

        generatePassword > "${secrets_dir}/${name}"
    done
}

JICOFO_AUTH_PASSWORD=$(generatePassword)
JVB_AUTH_PASSWORD=$(generatePassword)
JIGASI_XMPP_PASSWORD=$(generatePassword)
JIBRI_RECORDER_PASSWORD=$(generatePassword)
JIBRI_XMPP_PASSWORD=$(generatePassword)

sed -i.bak \
    -e "s#JICOFO_AUTH_PASSWORD=.*#JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD}#g" \
    -e "s#JVB_AUTH_PASSWORD=.*#JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}#g" \
    -e "s#JIGASI_XMPP_PASSWORD=.*#JIGASI_XMPP_PASSWORD=${JIGASI_XMPP_PASSWORD}#g" \
    -e "s#JIBRI_RECORDER_PASSWORD=.*#JIBRI_RECORDER_PASSWORD=${JIBRI_RECORDER_PASSWORD}#g" \
    -e "s#JIBRI_XMPP_PASSWORD=.*#JIBRI_XMPP_PASSWORD=${JIBRI_XMPP_PASSWORD}#g" \
    "$(dirname "$0")/.env"
