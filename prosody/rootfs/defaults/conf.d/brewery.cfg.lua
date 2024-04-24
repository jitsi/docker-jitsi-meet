{{ $REGION_NAME := .Env.PROSODY_REGION_NAME | default "default" -}}
{{ $RELEASE_NUMBER := .Env.RELEASE_NUMBER | default "" -}}
{{ $SHARD_NAME := .Env.SHARD | default "default" -}}
{{ $JVB_XMPP_AUTH_DOMAIN := .Env.JVB_XMPP_AUTH_DOMAIN | default "auth.jvb.meet.jitsi" -}}
{{ $JVB_XMPP_INTERNAL_MUC_DOMAIN := .Env.JVB_XMPP_INTERNAL_MUC_DOMAIN | default "muc.jvb.meet.jitsi" -}}
{{ $JVB_AUTH_USER := .Env.JVB_AUTH_USER | default "jvb" -}}

admins = {
    "focus@{{ $JVB_XMPP_AUTH_DOMAIN }}",
    "{{ $JVB_AUTH_USER }}@{{ $JVB_XMPP_AUTH_DOMAIN }}"
}

plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom", "/prosody-plugins-contrib" }

VirtualHost "{{ $JVB_XMPP_AUTH_DOMAIN }}"
    authentication = "internal_hashed"
    ssl = {
        key = "/config/certs/{{ $JVB_XMPP_AUTH_DOMAIN }}.key";
        certificate = "/config/certs/{{ $JVB_XMPP_AUTH_DOMAIN }}.crt";
    }

Component "{{ $JVB_XMPP_INTERNAL_MUC_DOMAIN }}" "muc"
    modules_enabled = {
      "muc_hide_all";
      "muc_filter_access";
    }
    storage = "memory"
    muc_room_cache_size = 10000
    muc_filter_whitelist="{{ $JVB_XMPP_AUTH_DOMAIN }}"
    muc_room_locking = false
    muc_room_default_public_jids = true

