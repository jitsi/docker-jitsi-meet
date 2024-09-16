{{ $C2S_REQUIRE_ENCRYPTION := .Env.PROSODY_C2S_REQUIRE_ENCRYPTION | default "1" | toBool -}}
{{ $ENABLE_AUTH := .Env.ENABLE_AUTH | default "0" | toBool -}}
{{ $ENABLE_VISITORS := .Env.ENABLE_VISITORS | default "0" | toBool -}}
{{ $AUTH_TYPE := .Env.AUTH_TYPE | default "internal" -}}
{{ $PROSODY_AUTH_TYPE := .Env.PROSODY_AUTH_TYPE | default $AUTH_TYPE -}}
{{ $ENABLE_GUEST_DOMAIN := and $ENABLE_AUTH (.Env.ENABLE_GUESTS | default "0" | toBool) -}}
{{ $ENABLE_RECORDING := .Env.ENABLE_RECORDING | default "0" | toBool -}}
{{ $ENABLE_RECORDING_METADATA := .Env.PROSODY_ENABLE_RECORDING_METADATA | default "1" | toBool -}}
{{ $ENABLE_TRANSCRIPTIONS := .Env.ENABLE_TRANSCRIPTIONS | default "0" | toBool -}}
{{ $JIBRI_XMPP_USER := .Env.JIBRI_XMPP_USER | default "jibri" -}}
{{ $JIGASI_XMPP_USER := .Env.JIGASI_XMPP_USER | default "jigasi" -}}
{{ $JVB_AUTH_USER := .Env.JVB_AUTH_USER | default "jvb" -}}
{{ $JWT_ASAP_KEYSERVER := .Env.JWT_ASAP_KEYSERVER | default "" -}}
{{ $JWT_ALLOW_EMPTY := .Env.JWT_ALLOW_EMPTY | default "0" | toBool -}}
{{ $JWT_AUTH_TYPE := .Env.JWT_AUTH_TYPE | default "token" -}}
{{ $JWT_ENABLE_DOMAIN_VERIFICATION := .Env.JWT_ENABLE_DOMAIN_VERIFICATION | default "false" | toBool -}}
{{ $MATRIX_UVS_ISSUER := .Env.MATRIX_UVS_ISSUER | default "issuer" -}}
{{ $MATRIX_UVS_SYNC_POWER_LEVELS := .Env.MATRIX_UVS_SYNC_POWER_LEVELS | default "0" | toBool -}}
{{ $MATRIX_LOBBY_BYPASS := .Env.MATRIX_LOBBY_BYPASS | default "0" | toBool -}}
{{ $JWT_TOKEN_AUTH_MODULE := .Env.JWT_TOKEN_AUTH_MODULE | default "token_verification" -}}
{{ $ENABLE_LOBBY := .Env.ENABLE_LOBBY | default "true" | toBool -}}
{{ $ENABLE_AV_MODERATION := .Env.ENABLE_AV_MODERATION | default "true" | toBool -}}
{{ $ENABLE_BREAKOUT_ROOMS := .Env.ENABLE_BREAKOUT_ROOMS | default "true" | toBool -}}
{{ $ENABLE_END_CONFERENCE := .Env.ENABLE_END_CONFERENCE | default "true" | toBool -}}
{{ $ENABLE_XMPP_WEBSOCKET := .Env.ENABLE_XMPP_WEBSOCKET | default "1" | toBool -}}
{{ $ENABLE_JAAS_COMPONENTS := .Env.ENABLE_JAAS_COMPONENTS | default "0" | toBool -}}
{{ $ENABLE_RATE_LIMITS := .Env.PROSODY_ENABLE_RATE_LIMITS | default "0" | toBool -}}
{{ $GUEST_AUTH_TYPE := .Env.PROSODY_GUEST_AUTH_TYPE | default "jitsi-anonymous" -}}
{{ $PUBLIC_URL := .Env.PUBLIC_URL | default "https://localhost:8443" -}}
{{ $PUBLIC_URL_DOMAIN := $PUBLIC_URL | trimPrefix "https://" | trimSuffix "/" -}}
{{ $STUN_HOST := .Env.STUN_HOST | default "" -}}
{{ $STUN_PORT := .Env.STUN_PORT | default "443" -}}
{{ $TURN_HOST := .Env.TURN_HOST | default "" -}}
{{ $TURN_HOSTS := splitList "," $TURN_HOST -}}
{{ $TURN_PORT := .Env.TURN_PORT | default "443" -}}
{{ $TURN_TRANSPORT := .Env.TURN_TRANSPORT | default "tcp" -}}
{{ $TURN_TRANSPORTS := splitList "," $TURN_TRANSPORT -}}
{{ $TURN_TTL := .Env.TURN_TTL | default "86400" -}}
{{ $TURNS_HOST := .Env.TURNS_HOST | default "" -}}
{{ $TURNS_HOSTS := splitList "," $TURNS_HOST -}}
{{ $TURNS_PORT := .Env.TURNS_PORT | default "443" -}}
{{ $XMPP_AUTH_DOMAIN := .Env.XMPP_AUTH_DOMAIN | default "auth.meet.jitsi" -}}
{{ $XMPP_DOMAIN := .Env.XMPP_DOMAIN | default "meet.jitsi" -}}
{{ $XMPP_GUEST_DOMAIN := .Env.XMPP_GUEST_DOMAIN | default "guest.meet.jitsi" -}}
{{ $XMPP_INTERNAL_MUC_DOMAIN := .Env.XMPP_INTERNAL_MUC_DOMAIN | default "internal-muc.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN := .Env.XMPP_MUC_DOMAIN | default "muc.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN_PREFIX := (split "." $XMPP_MUC_DOMAIN)._0 -}}
{{ $XMPP_RECORDER_DOMAIN := .Env.XMPP_RECORDER_DOMAIN | default "recorder.meet.jitsi" -}}
{{ $JIBRI_RECORDER_USER := .Env.JIBRI_RECORDER_USER | default "recorder" -}}
{{ $JIGASI_TRANSCRIBER_USER := .Env.JIGASI_TRANSCRIBER_USER | default "transcriber" -}}
{{ $DISABLE_POLLS := .Env.DISABLE_POLLS | default "false" | toBool -}}
{{ $ENABLE_SUBDOMAINS := .Env.ENABLE_SUBDOMAINS | default "true" | toBool -}}
{{ $PROSODY_RESERVATION_ENABLED := .Env.PROSODY_RESERVATION_ENABLED | default "false" | toBool -}}
{{ $PROSODY_RESERVATION_REST_BASE_URL := .Env.PROSODY_RESERVATION_REST_BASE_URL | default "" -}}
{{ $RATE_LIMIT_LOGIN_RATE := .Env.PROSODY_RATE_LIMIT_LOGIN_RATE | default "3" -}}
{{ $RATE_LIMIT_SESSION_RATE := .Env.PROSODY_RATE_LIMIT_SESSION_RATE | default "200" -}}
{{ $RATE_LIMIT_TIMEOUT := .Env.PROSODY_RATE_LIMIT_TIMEOUT | default "60" -}}
{{ $RATE_LIMIT_ALLOW_RANGES := .Env.PROSODY_RATE_LIMIT_ALLOW_RANGES | default "10.0.0.0/8" -}}
{{ $RATE_LIMIT_CACHE_SIZE := .Env.PROSODY_RATE_LIMIT_CACHE_SIZE | default "10000" -}}
{{ $ENV := .Env -}}

admins = {
    {{ if .Env.JIGASI_XMPP_PASSWORD }}
    "{{ $JIGASI_XMPP_USER }}@{{ $XMPP_AUTH_DOMAIN }}",
    {{ end }}

    {{ if .Env.JIBRI_XMPP_PASSWORD }}
    "{{ $JIBRI_XMPP_USER }}@{{ $XMPP_AUTH_DOMAIN }}",
    {{ end }}

    "focus@{{ $XMPP_AUTH_DOMAIN }}",
    "{{ $JVB_AUTH_USER }}@{{ $XMPP_AUTH_DOMAIN }}"
}

unlimited_jids = {
    "focus@{{ $XMPP_AUTH_DOMAIN }}",
    "{{ $JVB_AUTH_USER }}@{{ $XMPP_AUTH_DOMAIN }}"
}

plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom", "/prosody-plugins-contrib" }

muc_mapper_domain_base = "{{ $XMPP_DOMAIN }}";
muc_mapper_domain_prefix = "{{ $XMPP_MUC_DOMAIN_PREFIX }}";

http_default_host = "{{ $XMPP_DOMAIN }}"

{{ if .Env.TURN_CREDENTIALS -}}
external_service_secret = "{{.Env.TURN_CREDENTIALS}}";
{{- end }}

{{ if or .Env.STUN_HOST .Env.TURN_HOST .Env.TURNS_HOST -}}
external_services = {
  {{- if $STUN_HOST }}
        { type = "stun", host = "{{ $STUN_HOST }}", port = {{ $STUN_PORT }}, transport = "udp" }
  {{- end }}
  {{- if $TURN_HOST -}}
    {{- range $idx1, $host := $TURN_HOSTS -}}
      {{- range $idx2, $transport := $TURN_TRANSPORTS -}}
        {{- if or $STUN_HOST $idx1 $idx2 -}},{{- end }}
        { type = "turn", host = "{{ $host }}", port = {{ $TURN_PORT }}, transport = "{{ $transport }}", secret = true, ttl = {{ $TURN_TTL }}, algorithm = "turn" }
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if $TURNS_HOST -}}
    {{- range $idx, $host := $TURNS_HOSTS -}}
        {{- if or $STUN_HOST $TURN_HOST $idx -}},{{- end }}
        { type = "turns", host = "{{ $host }}", port = {{ $TURNS_PORT }}, transport = "tcp", secret = true, ttl = {{ $TURN_TTL }}, algorithm = "turn" }
    {{- end }}
  {{- end }}
};
{{- end }}

{{ if and $ENABLE_AUTH (or (eq $PROSODY_AUTH_TYPE "jwt") (eq $PROSODY_AUTH_TYPE "hybrid_matrix_token")) .Env.JWT_ACCEPTED_ISSUERS }}
asap_accepted_issuers = { "{{ join "\",\"" (splitList "," .Env.JWT_ACCEPTED_ISSUERS) }}" }
{{ end }}

{{ if and $ENABLE_AUTH (or (eq $PROSODY_AUTH_TYPE "jwt") (eq $PROSODY_AUTH_TYPE "hybrid_matrix_token")) .Env.JWT_ACCEPTED_AUDIENCES }}
asap_accepted_audiences = { "{{ join "\",\"" (splitList "," .Env.JWT_ACCEPTED_AUDIENCES) }}" }
{{ end }}

consider_bosh_secure = true;
consider_websocket_secure = true;

{{ if $ENABLE_XMPP_WEBSOCKET }}
smacks_max_unacked_stanzas = 5;
smacks_hibernation_time = 60;
smacks_max_old_sessions = 1;
{{ end }}

{{ if $ENABLE_JAAS_COMPONENTS }}
VirtualHost "jigasi.meet.jitsi"
    modules_enabled = {
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
  {{ if eq $PROSODY_AUTH_TYPE "jwt" }}
  {{ if .Env.JWT_SIGN_TYPE }}
       signature_algorithm = "{{ .Env.JWT_SIGN_TYPE }}"
    {{ end -}}
    authentication = "{{ $JWT_AUTH_TYPE }}"
    app_id = "{{ .Env.JWT_APP_ID }}"
    app_secret = "{{ .Env.JWT_APP_SECRET }}"
    allow_empty_token = {{ $JWT_ALLOW_EMPTY }}
    {{ if $JWT_ASAP_KEYSERVER }}
    asap_key_server = "{{ .Env.JWT_ASAP_KEYSERVER }}"
    {{ end }}
    enable_domain_verification = {{ $JWT_ENABLE_DOMAIN_VERIFICATION }}
  {{ else if eq $PROSODY_AUTH_TYPE "ldap" }}
    authentication = "cyrus"
    cyrus_application_name = "xmpp"
    allow_unencrypted_plain_auth = true
  {{ else if eq $PROSODY_AUTH_TYPE "matrix" }}
    authentication = "matrix_user_verification"
    app_id = "{{ $MATRIX_UVS_ISSUER }}"
    uvs_base_url = "{{ .Env.MATRIX_UVS_URL }}"
    {{ if .Env.MATRIX_UVS_AUTH_TOKEN }}
    uvs_auth_token = "{{ .Env.MATRIX_UVS_AUTH_TOKEN }}"
    {{ end }}
    {{ if $MATRIX_UVS_SYNC_POWER_LEVELS }}
    uvs_sync_power_levels = true
    {{ end }}
  {{ else if eq $PROSODY_AUTH_TYPE "hybrid_matrix_token" }}
    authentication = "hybrid_matrix_token"
    app_id = "{{ .Env.JWT_APP_ID }}"
    app_secret = "{{ .Env.JWT_APP_SECRET }}"
    allow_empty_token = {{ $JWT_ALLOW_EMPTY }}
    enable_domain_verification = {{ $JWT_ENABLE_DOMAIN_VERIFICATION }}

    uvs_base_url = "{{ .Env.MATRIX_UVS_URL }}"
    {{ if .Env.MATRIX_UVS_ISSUER }}
    uvs_issuer = "{{ .Env.MATRIX_UVS_ISSUER }}"
    {{ end }}
    {{ if .Env.MATRIX_UVS_AUTH_TOKEN }}
    uvs_auth_token = "{{ .Env.MATRIX_UVS_AUTH_TOKEN }}"
    {{ end }}
  {{ else if eq $PROSODY_AUTH_TYPE "internal" }}
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
        "{{ join "\";\n        \"" (splitList "," .Env.XMPP_MODULES) }}";
        {{ end }}
        {{ if and $ENABLE_AUTH (eq $PROSODY_AUTH_TYPE "ldap") }}
        "auth_cyrus";
        {{end}}
        {{ if $PROSODY_RESERVATION_ENABLED }}
        "reservations";
        {{ end }}
        {{ if $ENABLE_VISITORS }}
        "visitors";
        {{ end }}
        {{- if and $ENABLE_RECORDING_METADATA $ENABLE_AUTH (eq $PROSODY_AUTH_TYPE "jwt") $ENABLE_RECORDING }}
        "jibri_session";
        {{- end }}

    }

    main_muc = "{{ $XMPP_MUC_DOMAIN }}"
    room_metadata_component = "metadata.{{ $XMPP_DOMAIN }}"
    {{ if $ENABLE_LOBBY }}
    lobby_muc = "lobby.{{ $XMPP_DOMAIN }}"
    {{ if or $ENABLE_RECORDING $ENABLE_TRANSCRIPTIONS }}
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
    end_conference_component = "endconference.{{ $XMPP_DOMAIN }}"
    {{ end }}

    {{ if $ENABLE_AV_MODERATION }}
    av_moderation_component = "avmoderation.{{ $XMPP_DOMAIN }}"
    {{ end }}

    c2s_require_encryption = {{ $C2S_REQUIRE_ENCRYPTION }}

    {{ if $ENABLE_VISITORS -}}
    visitors_ignore_list = { "{{ $XMPP_RECORDER_DOMAIN }}" }
    {{ end }}

    {{ if .Env.XMPP_CONFIGURATION -}}
    {{ join "\n    " (splitList "," .Env.XMPP_CONFIGURATION) }}
    {{ end -}}

{{ if $ENABLE_GUEST_DOMAIN }}
VirtualHost "{{ $XMPP_GUEST_DOMAIN }}"
    authentication = "{{ $GUEST_AUTH_TYPE }}"
    modules_enabled = {
        {{ if $ENABLE_XMPP_WEBSOCKET }}
        "smacks"; -- XEP-0198: Stream Management
        {{ end }}
    }

    c2s_require_encryption = {{ $C2S_REQUIRE_ENCRYPTION }}
    {{ if $ENABLE_VISITORS }}
    allow_anonymous_s2s = true
    {{ end }}

{{ end }}

VirtualHost "{{ $XMPP_AUTH_DOMAIN }}"
    ssl = {
        key = "/config/certs/{{ $XMPP_AUTH_DOMAIN }}.key";
        certificate = "/config/certs/{{ $XMPP_AUTH_DOMAIN }}.crt";
    }
    modules_enabled = {
        "limits_exception";
        {{- if and $ENABLE_RECORDING_METADATA $ENABLE_AUTH (eq $PROSODY_AUTH_TYPE "jwt") $ENABLE_RECORDING }}
        "jibri_session";
        {{- end }}
    }
    authentication = "internal_hashed"

{{ if or $ENABLE_RECORDING $ENABLE_TRANSCRIPTIONS }}
VirtualHost "{{ $XMPP_RECORDER_DOMAIN }}"
    modules_enabled = {
      "smacks";
    }
    authentication = "internal_hashed"
{{ end }}

Component "{{ $XMPP_INTERNAL_MUC_DOMAIN }}" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_hide_all";
        "muc_filter_access";
        {{ if .Env.XMPP_INTERNAL_MUC_MODULES -}}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_INTERNAL_MUC_MODULES) }}";
        {{ end -}}
    }
    restrict_room_creation = true
    muc_filter_whitelist="{{ $XMPP_AUTH_DOMAIN }}"
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_room_cache_size = 1000
    muc_tombstones = false
    muc_room_allow_persistent = false

Component "{{ $XMPP_MUC_DOMAIN }}" "muc"
    restrict_room_creation = true
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        {{ if .Env.XMPP_MUC_MODULES -}}
        "{{ join "\";\n        \"" (splitList "," .Env.XMPP_MUC_MODULES) }}";
        {{ end -}}
        {{ if and $ENABLE_AUTH (or (eq $PROSODY_AUTH_TYPE "jwt") (eq $PROSODY_AUTH_TYPE "hybrid_matrix_token")) -}}
        "{{ $JWT_TOKEN_AUTH_MODULE }}";
        {{ end }}
        {{ if and $ENABLE_AUTH (eq $PROSODY_AUTH_TYPE "matrix") $MATRIX_UVS_SYNC_POWER_LEVELS -}}
        "matrix_power_sync";
        {{ end -}}
        {{ if and $ENABLE_AUTH (eq $PROSODY_AUTH_TYPE "hybrid_matrix_token") $MATRIX_UVS_SYNC_POWER_LEVELS -}}
        "matrix_affiliation";
        {{ end -}}
        {{ if and $ENABLE_AUTH (eq $PROSODY_AUTH_TYPE "hybrid_matrix_token") $MATRIX_LOBBY_BYPASS -}}
        "matrix_lobby_bypass";
        {{ end -}}
        {{ if not $DISABLE_POLLS -}}
        "polls";
        {{ end -}}
        {{ if $ENABLE_SUBDOMAINS -}}
        "muc_domain_mapper";
        {{ end -}}
        {{ if $ENABLE_RATE_LIMITS -}}
        "muc_rate_limit";
        "rate_limit";
        {{ end -}}
        {{ if .Env.MAX_PARTICIPANTS }}
        "muc_max_occupants";
        {{ end }}
        "muc_password_whitelist";
    }

    {{ if $ENABLE_RATE_LIMITS -}}
    -- Max allowed join/login rate in events per second.
    rate_limit_login_rate = {{ $RATE_LIMIT_LOGIN_RATE }};
    -- The rate to which sessions from IPs exceeding the join rate will be limited, in bytes per second.
    rate_limit_session_rate = {{ $RATE_LIMIT_SESSION_RATE }};
    -- The time in seconds, after which the limit for an IP address is lifted.
    rate_limit_timeout = {{ $RATE_LIMIT_TIMEOUT }};
    -- List of regular expressions for IP addresses that are not limited by this module.
    rate_limit_whitelist = {
        "127.0.0.1";
{{ range $index, $cidr := (splitList "," $RATE_LIMIT_ALLOW_RANGES) }}
        "{{ $cidr }}";
{{ end }}
    };

    rate_limit_whitelist_hosts = {
        "{{ $XMPP_RECORDER_DOMAIN }}";
    }
    {{ end -}}

	-- The size of the cache that saves state for IP addresses
    rate_limit_cache_size = {{ $RATE_LIMIT_CACHE_SIZE }};

    muc_room_cache_size = 10000
    muc_room_locking = false
    muc_room_default_public_jids = true
    {{ if .Env.XMPP_MUC_CONFIGURATION -}}
    {{ join "\n    " (splitList "," .Env.XMPP_MUC_CONFIGURATION) }}
    {{ end -}}
    {{ if .Env.MAX_PARTICIPANTS }}
    muc_access_whitelist = { "focus@{{ $XMPP_AUTH_DOMAIN }}" }
    muc_max_occupants = "{{ .Env.MAX_PARTICIPANTS }}"
    {{ end }}
    muc_password_whitelist = {
        "focus@{{ $XMPP_AUTH_DOMAIN }}";
{{- if $ENABLE_RECORDING }}
        "{{ $JIBRI_RECORDER_USER }}@{{ $XMPP_RECORDER_DOMAIN }}";
{{- end }}
{{- if $ENABLE_TRANSCRIPTIONS }}
        "{{ $JIGASI_TRANSCRIBER_USER }}@{{ $XMPP_RECORDER_DOMAIN }}";
{{- end }}
    }
    muc_tombstones = false
    muc_room_allow_persistent = false

Component "focus.{{ $XMPP_DOMAIN }}" "client_proxy"
    target_address = "focus@{{ $XMPP_AUTH_DOMAIN }}"

Component "speakerstats.{{ $XMPP_DOMAIN }}" "speakerstats_component"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"
    {{- if .Env.XMPP_SPEAKERSTATS_MODULES }}
    modules_enabled = {
        "{{ join "\";\n        \"" (splitList "," .Env.XMPP_SPEAKERSTATS_MODULES) }}";
    }
    {{- end }}

Component "conferenceduration.{{ $XMPP_DOMAIN }}" "conference_duration_component"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"

{{ if $ENABLE_END_CONFERENCE }}
Component "endconference.{{ $XMPP_DOMAIN }}" "end_conference"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"
{{ end }}

{{ if $ENABLE_AV_MODERATION }}
Component "avmoderation.{{ $XMPP_DOMAIN }}" "av_moderation_component"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"
{{ end }}

{{ if $ENABLE_LOBBY }}
Component "lobby.{{ $XMPP_DOMAIN }}" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_tombstones = false
    muc_room_allow_persistent = false
    muc_room_cache_size = 10000
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = {
        {{ if $ENABLE_RATE_LIMITS -}}
        "muc_rate_limit";
        {{ end -}}
        {{ if .Env.XMPP_LOBBY_MUC_MODULES -}}
        "{{ join "\";\n        \"" (splitList "," .Env.XMPP_LOBBY_MUC_MODULES) }}";
        {{ end -}}
    }

    {{ end }}

{{ if $ENABLE_BREAKOUT_ROOMS }}
Component "breakout.{{ $XMPP_DOMAIN }}" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_cache_size = 10000
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_tombstones = false
    muc_room_allow_persistent = false
    modules_enabled = {
        "muc_meeting_id";
        {{ if not $DISABLE_POLLS -}}
        "polls";
        {{ end -}}
        {{ if $ENABLE_RATE_LIMITS -}}
        "muc_rate_limit";
        {{ end -}}
        {{ if .Env.XMPP_BREAKOUT_MUC_MODULES -}}
        "{{ join "\";\n        \"" (splitList "," .Env.XMPP_BREAKOUT_MUC_MODULES) }}";
        {{ end -}}
    }
{{ end }}

Component "metadata.{{ $XMPP_DOMAIN }}" "room_metadata_component"
    muc_component = "{{ $XMPP_MUC_DOMAIN }}"
    breakout_rooms_component = "breakout.{{ $XMPP_DOMAIN }}"


{{ if $ENABLE_VISITORS }}
Component "visitors.{{ $XMPP_DOMAIN }}" "visitors_component"
    auto_allow_visitor_promotion = true
    always_visitors_enabled = true
{{ end }}
