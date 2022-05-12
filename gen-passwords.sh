#!/usr/bin/env bash
set -euo pipefail

function generatePassword() {
    openssl rand -hex 16
}

function generateSecrets() {
    source "${0%/*}/.env"

    local -r secrets_dir="${SECRETS_DIR:-"${0%/*}/.secrets"}"
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

generateSecrets
