admins = { "{{ .Env.JICOFO_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}" }
plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom" }
http_default_host = "{{ .Env.XMPP_DOMAIN }}"

{{ if and (.Env.ENABLE_AUTH | default "0" | toBool) (.Env.JWT_ENABLE_TOKEN_AUTH | default "0" | toBool) .Env.JWT_ACCEPTED_ISSUERS }}
asap_accepted_issuers = { "{{ join "\",\"" (splitList "," .Env.JWT_ACCEPTED_ISSUERS) }}" }
{{ end }}

{{ if and (.Env.ENABLE_AUTH | default "0" | toBool) (.Env.JWT_ENABLE_TOKEN_AUTH | default "0" | toBool) .Env.JWT_ACCEPTED_AUDIENCES }}
asap_accepted_audiences = { "{{ join "\",\"" (splitList "," .Env.JWT_ACCEPTED_AUDIENCES) }}" }
{{ end }}

VirtualHost "{{ .Env.XMPP_DOMAIN }}"
{{ if .Env.ENABLE_AUTH | default "0" | toBool }}
    {{ if .Env.JWT_ENABLE_TOKEN_AUTH | default "0" | toBool }}
    authentication = "token"
    app_id = "{{ .Env.JWT_APP_ID }}"
    app_secret = "{{ .Env.JWT_APP_SECRET }}"
    allow_empty_token = false
    {{ else }}
    authentication = "internal_plain"
    {{ end }}
{{ else }}
    authentication = "anonymous"
{{ end }}
    ssl = {
        key = "/config/certs/{{ .Env.XMPP_DOMAIN }}.key";
        certificate = "/config/certs/{{ .Env.XMPP_DOMAIN }}.crt";
    }
    modules_enabled = {
        "bosh";
        "pubsub";
        "ping";
        {{ if .Env.XMPP_MODULES }}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_MODULES) }}";
        {{ end }}
    }

    c2s_require_encryption = false

{{ if and (.Env.ENABLE_AUTH | default "0" | toBool) (.Env.ENABLE_GUESTS | default "0" | toBool) }}
VirtualHost "{{ .Env.XMPP_GUEST_DOMAIN }}"
    authentication = "anonymous"
    c2s_require_encryption = false
{{ end }}

VirtualHost "{{ .Env.XMPP_AUTH_DOMAIN }}"
    ssl = {
        key = "/config/certs/{{ .Env.XMPP_AUTH_DOMAIN }}.key";
        certificate = "/config/certs/{{ .Env.XMPP_AUTH_DOMAIN }}.crt";
    }
    authentication = "internal_plain"

Component "{{ .Env.XMPP_INTERNAL_MUC_DOMAIN }}" "muc"
    modules_enabled = {
        "ping";
        {{ if .Env.XMPP_INTERNAL_MUC_MODULES }}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_INTERNAL_MUC_MODULES) }}";
        {{ end }}
    }
    storage = "memory"
    muc_room_cache_size = 1000

Component "{{ .Env.XMPP_MUC_DOMAIN }}" "muc"
    storage = "memory"
    modules_enabled = {
        {{ if .Env.XMPP_MUC_MODULES }}
        "{{ join "\";\n\"" (splitList "," .Env.XMPP_MUC_MODULES) }}";
        {{ end }}
        {{ if .Env.JWT_ENABLE_TOKEN_AUTH | default "0" | toBool }}
        "token_verification";
        {{ end }}
    }

Component "focus.{{ .Env.XMPP_DOMAIN }}"
    component_secret = "{{ .Env.JICOFO_COMPONENT_SECRET }}"
