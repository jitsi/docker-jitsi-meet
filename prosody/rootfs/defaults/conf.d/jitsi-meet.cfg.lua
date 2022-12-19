{{ $ENABLE_AUTH := .Env.ENABLE_AUTH | default "0" | toBool }}
{{ $ENABLE_GUEST_DOMAIN := and $ENABLE_AUTH (.Env.ENABLE_GUESTS | default "0" | toBool)}}
{{ $ENABLE_RECORDING := .Env.ENABLE_RECORDING | default "0" | toBool }}
{{ $AUTH_TYPE := .Env.AUTH_TYPE | default "internal" }}
{{ $JIBRI_XMPP_USER := .Env.JIBRI_XMPP_USER | default "jibri" -}}
{{ $JICOFO_AUTH_USER := .Env.JICOFO_AUTH_USER | default "focus" -}}
{{ $JIGASI_XMPP_USER := .Env.JIGASI_XMPP_USER | default "jigasi" -}}
{{ $JVB_AUTH_USER := .Env.JVB_AUTH_USER | default "jvb" -}}
{{ $JWT_ASAP_KEYSERVER := .Env.JWT_ASAP_KEYSERVER | default "" }}
{{ $JWT_ALLOW_EMPTY := .Env.JWT_ALLOW_EMPTY | default "0" | toBool }}
{{ $JWT_AUTH_TYPE := .Env.JWT_AUTH_TYPE | default "token" }}
{{ $JWT_ENABLE_DOMAIN_VERIFICATION := .Env.JWT_ENABLE_DOMAIN_VERIFICATION | default "true" | toBool -}}
{{ $MATRIX_UVS_ISSUER := .Env.MATRIX_UVS_ISSUER | default "issuer" }}
{{ $MATRIX_UVS_SYNC_POWER_LEVELS := .Env.MATRIX_UVS_SYNC_POWER_LEVELS | default "0" | toBool }}
{{ $JWT_TOKEN_AUTH_MODULE := .Env.JWT_TOKEN_AUTH_MODULE | default "token_verification" }}
{{ $ENABLE_LOBBY := .Env.ENABLE_LOBBY | default "true" | toBool }}
{{ $ENABLE_AV_MODERATION := .Env.ENABLE_AV_MODERATION | default "true" | toBool }}
{{ $ENABLE_BREAKOUT_ROOMS := .Env.ENABLE_BREAKOUT_ROOMS | default "true" | toBool }}
{{ $ENABLE_END_CONFERENCE := .Env.ENABLE_END_CONFERENCE | default "true" | toBool }}
{{ $ENABLE_XMPP_WEBSOCKET := .Env.ENABLE_XMPP_WEBSOCKET | default "1" | toBool }}
{{ $ENABLE_JAAS_COMPONENTS := .Env.ENABLE_JAAS_COMPONENTS | default "0" | toBool }}
{{ $PUBLIC_URL := .Env.PUBLIC_URL | default "https://localhost:8443" -}}
{{ $PUBLIC_URL_DOMAIN := $PUBLIC_URL | trimPrefix "https://" | trimSuffix "/" -}}
{{ $TURN_PORT := .Env.TURN_PORT | default "443" }}
{{ $TURNS_PORT := .Env.TURNS_PORT | default "443" }}
{{ $TURN_TRANSPORT := .Env.TURN_TRANSPORT | default "tcp" -}}
{{ $TURN_TRANSPORTS := splitList "," $TURN_TRANSPORT -}}
{{ $XMPP_AUTH_DOMAIN := .Env.XMPP_AUTH_DOMAIN | default "auth.meet.jitsi" -}}
{{ $XMPP_DOMAIN := .Env.XMPP_DOMAIN | default "meet.jitsi" -}}
{{ $XMPP_GUEST_DOMAIN := .Env.XMPP_GUEST_DOMAIN | default "guest.meet.jitsi" -}}
{{ $XMPP_INTERNAL_MUC_DOMAIN := .Env.XMPP_INTERNAL_MUC_DOMAIN | default "internal-muc.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN := .Env.XMPP_MUC_DOMAIN | default "muc.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN_PREFIX := (split "." $XMPP_MUC_DOMAIN)._0 }}
{{ $XMPP_RECORDER_DOMAIN := .Env.XMPP_RECORDER_DOMAIN | default "recorder.meet.jitsi" -}}
{{ $DISABLE_POLLS := .Env.DISABLE_POLLS | default "false" | toBool -}}
{{ $ENABLE_SUBDOMAINS := .Env.ENABLE_SUBDOMAINS | default "true" | toBool -}}
{{ $PROSODY_RESERVATION_ENABLED := .Env.PROSODY_RESERVATION_ENABLED | default "false" | toBool }}
{{ $PROSODY_RESERVATION_REST_BASE_URL := .Env.PROSODY_RESERVATION_REST_BASE_URL | default "" }}
{{ $ENV := .Env -}}

admins = {
    {{ if .Env.JIGASI_XMPP_PASSWORD }}
    "{{ $JIGASI_XMPP_USER }}@{{ $XMPP_AUTH_DOMAIN }}",
    {{ end }}

    {{ if .Env.JIBRI_XMPP_PASSWORD }}
    "{{ $JIBRI_XMPP_USER }}@{{ $XMPP_AUTH_DOMAIN }}",
    {{ end }}

    "{{ $JICOFO_AUTH_USER }}@{{ $XMPP_AUTH_DOMAIN }}",
    "{{ $JVB_AUTH_USER }}@{{ $XMPP_AUTH_DOMAIN }}"
}

unlimited_jids = {
    "{{ $JICOFO_AUTH_USER }}@{{ $XMPP_AUTH_DOMAIN }}",
    "{{ $JVB_AUTH_USER }}@{{ $XMPP_AUTH_DOMAIN }}"
}

plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom" }

muc_mapper_domain_base = "{{ $XMPP_DOMAIN }}";
muc_mapper_domain_prefix = "{{ $XMPP_MUC_DOMAIN_PREFIX }}";

http_default_host = "{{ $XMPP_DOMAIN }}"

{{ if .Env.TURN_CREDENTIALS }}
external_service_secret = "{{.Env.TURN_CREDENTIALS}}";
{{ end }}

{{ if or .Env.TURN_HOST .Env.TURNS_HOST }}
external_services = {
  {{ if .Env.TURN_HOST }}
    {{ range $index, $transport := $TURN_TRANSPORTS }}
      {{ if gt $index 0 }}
  ,
      {{ end }}
     { type = "turn", host = "{{ $ENV.TURN_HOST }}", port = {{ $TURN_PORT }}, transport = "{{ $transport }}", secret = true, ttl = 86400, algorithm = "turn" }
    {{ end }}
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

{{ if $ENABLE_JAAS_COMPONENTS }}
VirtualHost "jigasi.meet.jitsi"
    modules_enabled = {
      "ping";
      "bosh";
      "muc_password_check";
    }
    authentication = "token"
    app_id = "jitsi";
    asap_key_server = "https://jaas-public-keys.jitsi.net/jitsi-components/prod-8x8"
    asap_accepted_issuers = { "jaas-components" }
    asap_accepted_audiences = { "jigasi.{{ $PUBLIC_URL_DOMAIN }}" }
{{ end }}

VirtualHost "{{ $XMPP_DOMAIN }}"
{{ if $ENABLE_AUTH }}
  {{ if eq $AUTH_TYPE "jwt" }}
    authentication = "{{ $JWT_AUTH_TYPE }}"
    app_id = "{{ .Env.JWT_APP_ID }}"
    app_secret = "{{ .Env.JWT_APP_SECRET }}"
    allow_empty_token = {{ $JWT_ALLOW_EMPTY }}
    {{ if $JWT_ASAP_KEYSERVER }}
    asap_key_server = "{{ .Env.JWT_ASAP_KEYSERVER }}"
    {{ end }}
    enable_domain_verification = {{ $JWT_ENABLE_DOMAIN_VERIFICATION }}
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
        key = "/config/certs/{{ $XMPP_DOMAIN }}.key";
        certificate = "/config/certs/{{ $XMPP_DOMAIN }}.crt";
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
        "room_metadata";
        {{ if $ENABLE_END_CONFERENCE }}
        "end_conference";
        {{ end }}
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
        {{ if $PROSODY_RESERVATION_ENABLED }}
        "reservations";
        {{ end }}
    }

    main_muc = "{{ $XMPP_MUC_DOMAIN }}"

    {{ if $ENABLE_LOBBY }}
    lobby_muc = "lobby.{{ $XMPP_DOMAIN }}"
    {{ if $ENABLE_RECORDING }}
    muc_lobby_whitelist = { "{{ $XMPP_RECORDER_DOMAIN }}" }
    {{ end }}
    {{ end }}

    {{ if $PROSODY_RESERVATION_ENABLED }}
    reservations_api_prefix = "{{ $PROSODY_RESERVATION_REST_BASE_URL }}"
    {{ end }}

    {{ if $ENABLE_BREAKOUT_ROOMS }}
    breakout_rooms_muc = "breakout.{{ $XMPP_DOMAIN }}"
    {{ end }}

    speakerstats_component = "speakerstats.{{ $XMPP_DOMAIN }}"
    conference_duration_component = "conferenceduration.{{ $XMPP_DOMAIN }}"

    {{ if $ENABLE_END_CONFERENCE }}
    end_conference_component = "endconference.{{ .Env.XMPP_DOMAIN }}"
    {{ end }}

    {{ if $ENABLE_AV_MODERATION }}
    av_moderation_component = "avmoderation.{{ $XMPP_DOMAIN }}"
    {{ end }}

    c2s_require_encryption = false

{{ if $ENABLE_GUEST_DOMAIN }}
VirtualHost "{{ $XMPP_GUEST_DOMAIN }}"
    authentication = "jitsi-anonymous"

    c2s_require_encryption = false
{{ end }}

VirtualHost "{{ $XMPP_AUTH_DOMAIN }}"
    ssl = {
        key = "/config/certs/{{ $XMPP_AUTH_DOMAIN }}.key";
        certificate = "/config/certs/{{ $XMPP_AUTH_DOMAIN }}.crt";
    }
    modules_enabled = {
        "limits_exception";
    }
    authentication = "internal_hashed"

{{ if $ENABLE_RECORDING }}
VirtualHost "{{ $XMPP_RECORDER_DOMAIN }}"
    modules_enabled = {
      "ping";
    }
    authentication = "internal_hashed"
{{ end }}

Component "{{ $XMPP_INTERNAL_MUC_DOMAIN }}" "muc"
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

Component "{{ $XMPP_MUC_DOMAIN }}" "muc"
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
        {{ if .Env.MAX_PARTICIPANTS }}
        "muc_max_occupants";
        {{ end }}
    }
    muc_room_cache_size = 1000
    muc_room_locking = false
    muc_room_default_public_jids = true
    {{ if .Env.XMPP_MUC_CONFIGURATION -}}
    {{ join "\n" (splitList "," .Env.XMPP_MUC_CONFIGURATION) }}
    {{ end -}}
    {{ if .Env.MAX_PARTICIPANTS }}
    muc_access_whitelist = { "{{ .Env.JICOFO_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}" }
    muc_max_occupants = "{{ .Env.MAX_PARTICIPANTS }}"
    {{ end }}

Component "focus.{{ $XMPP_DOMAIN }}" "client_proxy"
    target_address = "{{ $JICOFO_AUTH_USER }}@{{ $XMPP_AUTH_DOMAIN }}"

Component "speakerstats.{{ $XMPP_DOMAIN }}" "speakerstats_component"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"

Component "conferenceduration.{{ $XMPP_DOMAIN }}" "conference_duration_component"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"

{{ if $ENABLE_END_CONFERENCE }}
Component "endconference.{{ .Env.XMPP_DOMAIN }}" "end_conference"
    muc_component = "{{ .Env.XMPP_MUC_DOMAIN }}"
{{ end }}

{{ if $ENABLE_AV_MODERATION }}
Component "avmoderation.{{ $XMPP_DOMAIN }}" "av_moderation_component"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"
{{ end }}

{{ if $ENABLE_LOBBY }}
Component "lobby.{{ $XMPP_DOMAIN }}" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
{{ end }}

{{ if $ENABLE_BREAKOUT_ROOMS }}
Component "breakout.{{ $XMPP_DOMAIN }}" "muc"
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
