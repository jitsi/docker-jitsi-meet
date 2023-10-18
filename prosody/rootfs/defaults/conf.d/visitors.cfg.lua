{{ $ENABLE_AUTH := .Env.ENABLE_AUTH | default "0" | toBool -}}
{{ $ENABLE_GUEST_DOMAIN := and $ENABLE_AUTH (.Env.ENABLE_GUESTS | default "0" | toBool) -}}
{{ $ENABLE_RATE_LIMITS := .Env.PROSODY_ENABLE_RATE_LIMITS | default "0" | toBool -}}
{{ $ENABLE_SUBDOMAINS := .Env.ENABLE_SUBDOMAINS | default "true" | toBool -}}
{{ $ENABLE_XMPP_WEBSOCKET := .Env.ENABLE_XMPP_WEBSOCKET | default "1" | toBool -}}
{{ $JIBRI_RECORDER_USER := .Env.JIBRI_RECORDER_USER | default "recorder" -}}
{{ $JIGASI_TRANSCRIBER_USER := .Env.JIGASI_TRANSCRIBER_USER | default "transcriber" -}}
{{ $LIMIT_MESSAGES_CHECK_TOKEN := .Env.PROSODY_LIMIT_MESSAGES_CHECK_TOKEN | default "0" | toBool -}}
{{ $RATE_LIMIT_LOGIN_RATE := .Env.PROSODY_RATE_LIMIT_LOGIN_RATE | default "3" -}}
{{ $RATE_LIMIT_SESSION_RATE := .Env.PROSODY_RATE_LIMIT_SESSION_RATE | default "200" -}}
{{ $RATE_LIMIT_TIMEOUT := .Env.PROSODY_RATE_LIMIT_TIMEOUT | default "60" -}}
{{ $RATE_LIMIT_ALLOW_RANGES := .Env.PROSODY_RATE_LIMIT_ALLOW_RANGES | default "10.0.0.0/8" -}}
{{ $RATE_LIMIT_CACHE_SIZE := .Env.PROSODY_RATE_LIMIT_CACHE_SIZE | default "10000" -}}
{{ $REGION_NAME := .Env.PROSODY_REGION_NAME | default "default" -}}
{{ $RELEASE_NUMBER := .Env.RELEASE_NUMBER | default "" -}}
{{ $SHARD_NAME := .Env.SHARD | default "default" -}}
{{ $S2S_PORT := .Env.PROSODY_S2S_PORT | default "5269" -}}
{{ $TRUSTED_PROXIES := .Env.PROSODY_TRUSTED_PROXIES | default "127.0.0.1,::1" -}}
{{ $TRUSTED_PROXY_LIST := splitList "," $TRUSTED_PROXIES -}}
{{ $TURN_HOST := .Env.TURN_HOST | default "" -}}
{{ $TURN_HOSTS := splitList "," $TURN_HOST -}}
{{ $TURN_PORT := .Env.TURN_PORT | default "443" -}}
{{ $TURN_TRANSPORT := .Env.TURN_TRANSPORT | default "tcp" -}}
{{ $TURN_TRANSPORTS := splitList "," $TURN_TRANSPORT -}}
{{ $TURNS_HOST := .Env.TURNS_HOST | default "" -}}
{{ $TURNS_HOSTS := splitList "," $TURNS_HOST -}}
{{ $TURNS_PORT := .Env.TURNS_PORT | default "443" -}}
{{ $VISITOR_INDEX := .Env.PROSODY_VISITOR_INDEX | default "0" -}}
{{ $VISITORS_MUC_PREFIX := .Env.PROSODY_VISITORS_MUC_PREFIX | default "muc" -}}
{{ $VISITORS_MAX_VISITORS_PER_NODE := .Env.VISITORS_MAX_VISITORS_PER_NODE | default "250" }}
{{ $VISITORS_XMPP_DOMAIN := .Env.VISITORS_XMPP_DOMAIN | default "meet.jitsi" -}}
{{ $XMPP_AUTH_DOMAIN := .Env.XMPP_AUTH_DOMAIN | default "auth.meet.jitsi" -}}
{{ $XMPP_DOMAIN := .Env.XMPP_DOMAIN | default "meet.jitsi" -}}
{{ $XMPP_GUEST_DOMAIN := .Env.XMPP_GUEST_DOMAIN | default "guest.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN := .Env.XMPP_MUC_DOMAIN | default "muc.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN_PREFIX := (split "." $XMPP_MUC_DOMAIN)._0 -}}
{{ $XMPP_SERVER := .Env.XMPP_SERVER | default "xmpp.meet.jitsi" -}}
{{ $XMPP_SERVER_S2S_PORT := .Env.XMPP_SERVER_S2S_PORT | default $S2S_PORT -}}
{{ $XMPP_RECORDER_DOMAIN := .Env.XMPP_RECORDER_DOMAIN | default "recorder.meet.jitsi" -}}

plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom" }

muc_mapper_domain_base = "v{{ $VISITOR_INDEX }}.{{ $VISITORS_XMPP_DOMAIN }}";
muc_mapper_domain_prefix = "{{ $XMPP_MUC_DOMAIN_PREFIX }}";

http_default_host = "v{{ $VISITOR_INDEX }}.{{ $VISITORS_XMPP_DOMAIN }}"

{{ if .Env.TURN_CREDENTIALS -}}
external_service_secret = "{{.Env.TURN_CREDENTIALS}}";
{{- end }}

{{ if or .Env.TURN_HOST .Env.TURNS_HOST -}}
external_services = {
  {{ if $TURN_HOST -}}
    {{- range $idx1, $host := $TURN_HOSTS -}}
      {{- range $idx2, $transport := $TURN_TRANSPORTS -}}
        {{- if or $idx1 $idx2 -}},{{- end }}
        { type = "turn", host = "{{ $host }}", port = {{ $TURN_PORT }}, transport = "{{ $transport }}", secret = true, ttl = 86400, algorithm = "turn" }
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if $TURNS_HOST -}}
    {{- range $idx, $host := $TURNS_HOSTS -}}
        {{- if or $TURN_HOST $idx -}},{{- end }}
        { type = "turns", host = "{{ $host }}", port = {{ $TURNS_PORT }}, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" }
    {{- end }}
  {{- end }}
};
{{- end }}

main_domain = '{{ $XMPP_DOMAIN }}';

-- https://prosody.im/doc/modules/mod_smacks
smacks_max_unacked_stanzas = 5;
smacks_hibernation_time = 60;
-- this is dropped in 0.12
smacks_max_hibernated_sessions = 1;
smacks_max_old_sessions = 1;

unlimited_jids = { "focus@{{ $XMPP_AUTH_DOMAIN }}" }
limits = {
    c2s = {
        rate = "512kb/s";
    };
}

authentication = 'internal_hashed'
storage = 'internal'

consider_websocket_secure = true;
consider_bosh_secure = true;
bosh_max_inactivity = 60;

trusted_proxies = {
{{ range $index, $proxy := $TRUSTED_PROXY_LIST }}
  "{{ $proxy }}";
{{ end }}
}

-- this is added to make certs_s2soutinjection work
s2sout_override = {
    ["{{ $XMPP_MUC_DOMAIN }}"] = "tcp://{{ $XMPP_SERVER }}:{{ $XMPP_SERVER_S2S_PORT }}"; -- needed for visitors to send messages to main room
    ["{{ $XMPP_DOMAIN }}"] = "tcp://{{ $XMPP_SERVER }}:{{ $XMPP_SERVER_S2S_PORT }}";
    ["visitors.{{ $XMPP_DOMAIN }}"] = "tcp://{{ $XMPP_SERVER }}:{{ $XMPP_SERVER_S2S_PORT }}";
{{ if $ENABLE_GUEST_DOMAIN -}}
    ["{{ $XMPP_GUEST_DOMAIN }}"] = "tcp://{{ $XMPP_SERVER }}:{{ $XMPP_SERVER_S2S_PORT }}";
{{ end -}}
}

muc_limit_messages_count = 10;
muc_limit_messages_check_token = {{ $LIMIT_MESSAGES_CHECK_TOKEN }};

----------- Virtual hosts -----------
VirtualHost 'v{{ $VISITOR_INDEX }}.{{ $VISITORS_XMPP_DOMAIN }}'
    authentication = 'jitsi-anonymous'
    ssl = {
        key = "/config/certs/v{{ $VISITOR_INDEX }}.{{ $VISITORS_XMPP_DOMAIN }}.key";
        certificate = "/config/certs/v{{ $VISITOR_INDEX }}.{{ $VISITORS_XMPP_DOMAIN }}.crt";
    }
    modules_enabled = {
      'bosh';
      'ping';
      "external_services";
      {{ if $ENABLE_XMPP_WEBSOCKET -}}
      "websocket";
      "smacks"; -- XEP-0198: Stream Management
      {{ end -}}
      {{ if .Env.XMPP_MODULES }}
      "{{ join "\";\n\"" (splitList "," .Env.XMPP_MODULES) }}";
      {{ end }}
    }
    main_muc = '{{ $VISITORS_MUC_PREFIX }}.v{{ $VISITOR_INDEX }}.{{ $VISITORS_XMPP_DOMAIN }}';
    shard_name = "{{ $SHARD_NAME }}"
    region_name = "{{ $REGION_NAME }}"
    release_number = "{{ $RELEASE_NUMBER }}"

    {{ if .Env.XMPP_CONFIGURATION -}}
    {{ join "\n    " (splitList "," .Env.XMPP_CONFIGURATION) }}
    {{ end -}}


VirtualHost '{{ $XMPP_AUTH_DOMAIN}}'
    modules_enabled = {
      'limits_exception';
      'ping';
    }
    authentication = 'internal_hashed'

Component '{{ $VISITORS_MUC_PREFIX }}.v{{ $VISITOR_INDEX }}.{{ $VISITORS_XMPP_DOMAIN }}' 'muc'
    storage = 'memory'
    muc_room_cache_size = 10000
    restrict_room_creation = true
    modules_enabled = {
        "muc_hide_all";
        "muc_meeting_id";
        'fmuc';
        's2s_bidi';
        's2s_whitelist';
        's2sout_override';
        'muc_max_occupants';
        {{ if $ENABLE_SUBDOMAINS -}}
        "muc_domain_mapper";
        {{ end -}}
        {{ if $ENABLE_RATE_LIMITS -}}
        "muc_rate_limit";
        "rate_limit";
        {{ end -}}
        {{ if .Env.XMPP_MUC_MODULES -}}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_MUC_MODULES) }}";
        {{ end -}}
      }
    muc_room_default_presence_broadcast = {
        visitor = false;
        participant = true;
        moderator = true;
    };
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_max_occupants = {{ $VISITORS_MAX_VISITORS_PER_NODE}}
    muc_access_whitelist = {
        "{{ $XMPP_DOMAIN }}";
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
      {{ range $index, $cidr := (splitList "," $RATE_LIMIT_ALLOW_RANGES) -}}
      "{{ $cidr }}";
      {{ end -}}
    };

    rate_limit_whitelist_jids = {
        "{{ $JIBRI_RECORDER_USER }}@{{ $XMPP_RECORDER_DOMAIN }}",
        "{{ $JIGASI_TRANSCRIBER_USER }}@{{ $XMPP_RECORDER_DOMAIN }}"    
    }
    {{ end -}}

	-- The size of the cache that saves state for IP addresses
    rate_limit_cache_size = {{ $RATE_LIMIT_CACHE_SIZE }};

    muc_rate_joins = 30;
    {{ if .Env.XMPP_MUC_CONFIGURATION -}}
    {{ join "\n" (splitList "," .Env.XMPP_MUC_CONFIGURATION) }}
    {{ end -}}
