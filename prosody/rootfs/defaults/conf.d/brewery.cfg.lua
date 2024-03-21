{{ $REGION_NAME := .Env.PROSODY_REGION_NAME | default "default" -}}
{{ $RELEASE_NUMBER := .Env.RELEASE_NUMBER | default "" -}}
{{ $SHARD_NAME := .Env.SHARD | default "default" -}}
{{ $JVB_XMPP_AUTH_DOMAIN := .Env.JVB_XMPP_AUTH_DOMAIN | default "auth.jvb.meet.jitsi" -}}
{{ $JVB_XMPP_INTERNAL_MUC_DOMAIN := .Env.JVB_XMPP_INTERNAL_MUC_DOMAIN | default "muc.jvb.meet.jitsi" -}}
{{ $JVB_AUTH_USER := .Env.JVB_AUTH_USER | default "jvb" -}}

{{ $GC_TYPE := .Env.GC_TYPE | default "generational" -}}
{{ $GC_INC_TH := .Env.GC_INC_TH | default 150 -}}
{{ $GC_INC_SPEED := .Env.GC_INC_SPEED | default 250 -}}
{{ $GC_INC_STEP_SIZE := .Env.GC_INC_STEP_SIZE | default 13 -}}
{{ $GC_GEN_MIN_TH := .Env.GC_GEN_MIN_TH | default 20 -}}
{{ $GC_GEN_MAX_TH := .Env.GC_GEN_MAX_TH | default 100 -}}

--Prosody garbage collector settings
--For more information see https://prosody.im/doc/advanced_gc
{{ if eq $GC_TYPE "generational" }}
gc = {
    mode = "generational";
    minor_threshold = {{ $GC_GEN_MIN_TH }};
    major_threshold = {{ $GC_GEN_MAX_TH }};
}
{{ else }}
gc = {
	mode = "incremental";
	threshold = {{ $GC_INC_TH }};
	speed = {{ $GC_INC_SPEED }};
	step_size = {{ $GC_INC_STEP_SIZE }};
}
{{ end }}

admins = {
    "focus@{{ $JVB_XMPP_AUTH_DOMAIN }}",
    "{{ $JVB_AUTH_USER }}@{{ $JVB_XMPP_AUTH_DOMAIN }}"
}

plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom" }

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

