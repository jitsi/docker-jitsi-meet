admins = { "{{ .Env.JICOFO_AUTH_USER }}@{{ .Env.XMPP_AUTH_DOMAIN }}" }

VirtualHost "{{ .Env.XMPP_DOMAIN }}"
    {{ if .Env.ENABLE_AUTH }}
    authentication = "internal_plain"
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
    }

    c2s_require_encryption = false

{{ if and .Env.ENABLE_AUTH .Env.ENABLE_GUESTS }}
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
    }
    storage = "internal"
    muc_room_cache_size = 1000

Component "{{ .Env.XMPP_MUC_DOMAIN }}" "muc"
    storage = "internal"

Component "focus.{{ .Env.XMPP_DOMAIN }}"
    component_secret = "{{ .Env.JICOFO_COMPONENT_SECRET }}"

