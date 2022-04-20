#!/usr/bin/env bash
set -euo pipefail

function generatePassword() {
    # there is a clean base64 conversion we can use:
    #   where:
    #       R = random bytes count
    #       L = base64 string length
    #   L = R(4/3)
    # therefore 48 will generate a 64 character base64 string
    head -c 48 /dev/urandom | base64 -w0
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

generateSecrets
