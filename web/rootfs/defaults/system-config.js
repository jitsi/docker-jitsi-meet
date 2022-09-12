{{ $CONFIG_EXTERNAL_CONNECT := .Env.CONFIG_EXTERNAL_CONNECT | default "false" | toBool -}}
{{ $ENABLE_AUTH := .Env.ENABLE_AUTH | default "false" | toBool -}}
{{ $ENABLE_GUESTS := .Env.ENABLE_GUESTS | default "false" | toBool -}}
{{ $ENABLE_SUBDOMAINS := .Env.ENABLE_SUBDOMAINS | default "true" | toBool -}}
{{ $ENABLE_XMPP_WEBSOCKET := .Env.ENABLE_XMPP_WEBSOCKET | default "1" | toBool -}}
{{ $JICOFO_AUTH_USER := .Env.JICOFO_AUTH_USER | default "focus" -}}
{{ $PUBLIC_URL_DOMAIN := .Env.PUBLIC_URL | default "https://localhost:8443" | trimPrefix "https://" | trimSuffix "/" -}}
{{ $XMPP_AUTH_DOMAIN := .Env.XMPP_AUTH_DOMAIN | default "auth.meet.jitsi" -}}
{{ $XMPP_DOMAIN := .Env.XMPP_DOMAIN | default "meet.jitsi" -}}
{{ $XMPP_GUEST_DOMAIN := .Env.XMPP_GUEST_DOMAIN | default "guest.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN := .Env.XMPP_MUC_DOMAIN | default "muc.meet.jitsi" -}}
{{ $XMPP_MUC_DOMAIN_PREFIX := (split "." $XMPP_MUC_DOMAIN)._0  -}}

// Jitsi Meet configuration.
var config = {};

if (!config.hasOwnProperty('hosts')) config.hosts = {};

config.hosts.domain = '{{ $XMPP_DOMAIN }}';
config.focusUserJid = '{{$JICOFO_AUTH_USER}}@{{$XMPP_AUTH_DOMAIN}}';

{{ if $ENABLE_SUBDOMAINS -}}
var subdir = '<!--# echo var="subdir" default="" -->';
var subdomain = "<!--# echo var="subdomain" default="" -->";
if (subdir.startsWith('<!--')) {
    subdir = '';
}
if (subdomain) {
    subdomain = subdomain.substr(0,subdomain.length-1).split('.').join('_').toLowerCase() + '.';
}
config.hosts.muc = '{{ $XMPP_MUC_DOMAIN_PREFIX }}.' + subdomain + '{{ $XMPP_DOMAIN }}';
{{ else -}}
config.hosts.muc = '{{ $XMPP_MUC_DOMAIN }}';
{{ end -}}

{{ if $ENABLE_AUTH -}}
{{ if $ENABLE_GUESTS -}}
// When using authentication, domain for guest users.
config.hosts.anonymousdomain = '{{ $XMPP_GUEST_DOMAIN }}';
{{ end -}}
// Domain for authenticated users. Defaults to <domain>.
config.hosts.authdomain = '{{ $XMPP_DOMAIN }}';
{{ end -}}

{{ if $ENABLE_SUBDOMAINS -}}
config.bosh = '/' + subdir + 'http-bind';
{{ else -}}
config.bosh = '/http-bind';
{{ end -}}

{{ if $ENABLE_XMPP_WEBSOCKET -}}
{{ if $ENABLE_SUBDOMAINS -}}
config.websocket = 'wss://{{ $PUBLIC_URL_DOMAIN }}/' + subdir + 'xmpp-websocket';
{{ else -}}
config.websocket = 'wss://{{ $PUBLIC_URL_DOMAIN }}/xmpp-websocket';
{{ end -}}
{{ end -}}

{{ if $CONFIG_EXTERNAL_CONNECT -}}
{{ if $ENABLE_SUBDOMAINS -}}
config.externalConnectUrl = '/' + subdir + 'http-pre-bind';
{{ else -}}
config.externalConnectUrl = '/http-pre-bind';
{{ end -}}
{{ end -}}
