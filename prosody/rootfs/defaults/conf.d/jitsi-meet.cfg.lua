{{ $ENABLE_AUTH := .Env.ENABLE_AUTH | default "0" | toBool }}
{{ $ENABLE_GUEST_DOMAIN := and $ENABLE_AUTH (.Env.ENABLE_GUESTS | default "0" | toBool)}}
{{ $AUTH_TYPE := .Env.AUTH_TYPE | default "internal" }}
{{ $JWT_ASAP_KEYSERVER := .Env.JWT_ASAP_KEYSERVER | default "" }}
{{ $JWT_ALLOW_EMPTY := .Env.JWT_ALLOW_EMPTY | default "0" | toBool }}
{{ $JWT_AUTH_TYPE := .Env.JWT_AUTH_TYPE | default "token" }}
{{ $MATRIX_UVS_ISSUER := .Env.MATRIX_UVS_ISSUER | default "issuer" }}
{{ $MATRIX_UVS_SYNC_POWER_LEVELS := .Env.MATRIX_UVS_SYNC_POWER_LEVELS | default "0" | toBool }}
{{ $JWT_TOKEN_AUTH_MODULE := .Env.JWT_TOKEN_AUTH_MODULE | default "token_verification" }}
{{ $ENABLE_LOBBY := .Env.ENABLE_LOBBY | default "true" | toBool }}
{{ $ENABLE_AV_MODERATION := .Env.ENABLE_AV_MODERATION | default "true" | toBool }}
{{ $ENABLE_BREAKOUT_ROOMS := .Env.ENABLE_BREAKOUT_ROOMS | default "true" | toBool }}
{{ $ENABLE_XMPP_WEBSOCKET := .Env.ENABLE_XMPP_WEBSOCKET | default "1" | toBool }}
{{ $PUBLIC_URL := .Env.PUBLIC_URL | default "https://localhost:8443" -}}
{{ $TURN_PORT := .Env.TURN_PORT | default "443" }}
{{ $TURNS_PORT := .Env.TURNS_PORT | default "443" }}
{{ $XMPP_MUC_DOMAIN_PREFIX := (split "." .Env.XMPP_MUC_DOMAIN)._0 }}
{{ $DISABLE_POLLS := .Env.DISABLE_POLLS | default "false" | toBool -}}
{{ $ENABLE_SUBDOMAINS := .Env.ENABLE_SUBDOMAINS | default "true" | toBool -}}

admins = {
    "{{ .Env.JICOFO_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}",
    "{{ .Env.JVB_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}"
}

unlimited_jids = {
    "{{ .Env.JICOFO_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}",
    "{{ .Env.JVB_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}"
}

plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom" }

muc_mapper_domain_base = "{{ .Env.XMPP_DOMAIN }}";
muc_mapper_domain_prefix = "{{ $XMPP_MUC_DOMAIN_PREFIX }}";

http_default_host = "{{ .Env.XMPP_DOMAIN }}"

{{ if .Env.TURN_CREDENTIALS }}
external_service_secret = "{{.Env.TURN_CREDENTIALS}}";
{{ end }}

{{ if or .Env.TURN_HOST .Env.TURNS_HOST }}
external_services = {
  {{ if .Env.TURN_HOST }}
     { type = "turn", host = "{{ .Env.TURN_HOST }}", port = {{ $TURN_PORT }}, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" }
  {{ end }}
  {{ if and .Env.TURN_HOST .Env.TURNS_HOST }}
  ,
  {{ end }}
  {{ if .Env.TURNS_HOST }}
     { type = "turns", host = "{{ .Env.TURNS_HOST }}", port = {{ $TURNS_PORT }}, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" }
  {{ end }}
};
{{ end }}

{{ if and $ENABLE_AUTH (eq $AUTH_TYPE "jwt") .Env.JWT_ACCEPTED_ISSUERS }}
asap_accepted_issuers = { "{{ join "\",\"" (splitList "," .Env.JWT_ACCEPTED_ISSUERS) }}" }
{{ end }}

{{ if and $ENABLE_AUTH (eq $AUTH_TYPE "jwt") .Env.JWT_ACCEPTED_AUDIENCES }}
asap_accepted_audiences = { "{{ join "\",\"" (splitList "," .Env.JWT_ACCEPTED_AUDIENCES) }}" }
{{ end }}

consider_bosh_secure = true;
consider_websocket_secure = true;

VirtualHost "{{ .Env.XMPP_DOMAIN }}"
{{ if $ENABLE_AUTH }}
  {{ if eq $AUTH_TYPE "jwt" }}
    authentication = "{{ $JWT_AUTH_TYPE }}"
    app_id = "{{ .Env.JWT_APP_ID }}"
    app_secret = "{{ .Env.JWT_APP_SECRET }}"
    allow_empty_token = {{ $JWT_ALLOW_EMPTY }}
    {{ if $JWT_ASAP_KEYSERVER }}
    asap_key_server = "{{ .Env.JWT_ASAP_KEYSERVER }}"
    {{ end }}
  {{ else if eq $AUTH_TYPE "ldap" }}
    authentication = "cyrus"
    cyrus_application_name = "xmpp"
    allow_unencrypted_plain_auth = true
  {{ else if eq $AUTH_TYPE "matrix" }}
    authentication = "matrix_user_verification"
    app_id = "{{ $MATRIX_UVS_ISSUER }}"
    uvs_base_url = "{{ .Env.MATRIX_UVS_URL }}"
    {{ if .Env.MATRIX_UVS_AUTH_TOKEN }}
    uvs_auth_token = "{{ .Env.MATRIX_UVS_AUTH_TOKEN }}"
    {{ end }}
    {{ if $MATRIX_UVS_SYNC_POWER_LEVELS }}
    uvs_sync_power_levels = true
    {{ end }}
  {{ else if eq $AUTH_TYPE "internal" }}
    authentication = "internal_hashed"
  {{ end }}
{{ else }}
    authentication = "jitsi-anonymous"
{{ end }}
    ssl = {
        key = "/config/certs/{{ .Env.XMPP_DOMAIN }}.key";
        certificate = "/config/certs/{{ .Env.XMPP_DOMAIN }}.crt";
    }
    modules_enabled = {
        "bosh";
        {{ if $ENABLE_XMPP_WEBSOCKET }}
        "websocket";
        "smacks"; -- XEP-0198: Stream Management
        {{ end }}
        "pubsub";
        "ping";
        "speakerstats";
        "conference_duration";
        {{ if or .Env.TURN_HOST .Env.TURNS_HOST }}
        "external_services";
        {{ end }}
        {{ if $ENABLE_LOBBY }}
        "muc_lobby_rooms";
        {{ end }}
        {{ if $ENABLE_BREAKOUT_ROOMS }}
        "muc_breakout_rooms";
        {{ end }}
        {{ if $ENABLE_AV_MODERATION }}
        "av_moderation";
        {{ end }}
        {{ if .Env.XMPP_MODULES }}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_MODULES) }}";
        {{ end }}
        {{ if and $ENABLE_AUTH (eq $AUTH_TYPE "ldap") }}
        "auth_cyrus";
        {{end}}
    }

    main_muc = "{{ .Env.XMPP_MUC_DOMAIN }}"

    {{ if $ENABLE_LOBBY }}
    lobby_muc = "lobby.{{ .Env.XMPP_DOMAIN }}"
    {{ if .Env.XMPP_RECORDER_DOMAIN }}
    muc_lobby_whitelist = { "{{ .Env.XMPP_RECORDER_DOMAIN }}" }
    {{ end }}
    {{ end }}

    {{ if $ENABLE_BREAKOUT_ROOMS }}
    breakout_rooms_muc = "breakout.{{ .Env.XMPP_DOMAIN }}"
    {{ end }}

    speakerstats_component = "speakerstats.{{ .Env.XMPP_DOMAIN }}"
    conference_duration_component = "conferenceduration.{{ .Env.XMPP_DOMAIN }}"

    {{ if $ENABLE_AV_MODERATION }}
    av_moderation_component = "avmoderation.{{ .Env.XMPP_DOMAIN }}"
    {{ end }}

    c2s_require_encryption = false

{{ if $ENABLE_GUEST_DOMAIN }}
VirtualHost "{{ .Env.XMPP_GUEST_DOMAIN }}"
    authentication = "jitsi-anonymous"

    c2s_require_encryption = false
{{ end }}

VirtualHost "{{ .Env.XMPP_AUTH_DOMAIN }}"
    ssl = {
        key = "/config/certs/{{ .Env.XMPP_AUTH_DOMAIN }}.key";
        certificate = "/config/certs/{{ .Env.XMPP_AUTH_DOMAIN }}.crt";
    }
    modules_enabled = {
        "limits_exception";
    }
    authentication = "internal_hashed"

{{ if .Env.XMPP_RECORDER_DOMAIN }}
VirtualHost "{{ .Env.XMPP_RECORDER_DOMAIN }}"
    modules_enabled = {
      "ping";
    }
    authentication = "internal_hashed"
{{ end }}

Component "{{ .Env.XMPP_INTERNAL_MUC_DOMAIN }}" "muc"
    storage = "memory"
    modules_enabled = {
        "ping";
        {{ if .Env.XMPP_INTERNAL_MUC_MODULES -}}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_INTERNAL_MUC_MODULES) }}";
        {{ end -}}
    }
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "{{ .Env.XMPP_MUC_DOMAIN }}" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        {{ if .Env.XMPP_MUC_MODULES -}}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_MUC_MODULES) }}";
        {{ end -}}
        {{ if and $ENABLE_AUTH (eq $AUTH_TYPE "jwt") -}}
        "{{ $JWT_TOKEN_AUTH_MODULE }}";
        {{ end }}
        {{ if and $ENABLE_AUTH (eq $AUTH_TYPE "matrix") $MATRIX_UVS_SYNC_POWER_LEVELS -}}
        "matrix_power_sync";
        {{ end -}}
        {{ if not $DISABLE_POLLS -}}
        "polls";
        {{ end -}}
        {{ if $ENABLE_SUBDOMAINS -}}
        "muc_domain_mapper";
        {{ end -}}
    }
    muc_room_cache_size = 1000
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "focus.{{ .Env.XMPP_DOMAIN }}" "client_proxy"
    target_address = "{{ .Env.JICOFO_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}"

Component "speakerstats.{{ .Env.XMPP_DOMAIN }}" "speakerstats_component"
    muc_component = "{{ .Env.XMPP_MUC_DOMAIN }}"

Component "conferenceduration.{{ .Env.XMPP_DOMAIN }}" "conference_duration_component"
    muc_component = "{{ .Env.XMPP_MUC_DOMAIN }}"

{{ if $ENABLE_AV_MODERATION }}
Component "avmoderation.{{ .Env.XMPP_DOMAIN }}" "av_moderation_component"
    muc_component = "{{ .Env.XMPP_MUC_DOMAIN }}"
{{ end }}

{{ if $ENABLE_LOBBY }}
Component "lobby.{{ .Env.XMPP_DOMAIN }}" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
{{ end }}

{{ if $ENABLE_BREAKOUT_ROOMS }}
Component "breakout.{{ .Env.XMPP_DOMAIN }}" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = {
        "muc_meeting_id";
        {{ if $ENABLE_SUBDOMAINS -}}
        "muc_domain_mapper";
        {{ end -}}
        {{ if not $DISABLE_POLLS -}}
        "polls";
        {{ end -}}
    }
{{ end }}
