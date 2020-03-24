/**
 * Overrides for the default configuration for Spot. See file default-config.js
 * for all the default values which are used.
 */
window.JitsiMeetSpotConfig = {
{{ $SPOT_DOMAIN := trimPrefix "https://" .Env.PUBLIC_URL }}
    DEFAULT_MEETING_DOMAIN: '{{ $SPOT_DOMAIN }}',
    EXTERNAL_API_SRC: '{{ .Env.PUBLIC_URL }}/external_api.js',
{{ if .Env.SPOT_BG_IMAGE }}
    DEFAULT_BACKGROUND_IMAGE_URL: '{{ .Env.SPOT_BG_IMAGE }}',
{{ end }}
    CALENDARS: {
{{ if .Env.SPOT_GOOGLE_CALENDAR_ID }}
        GOOGLE: {
            CLIENT_ID: '{{ .Env.SPOT_GOOGLE_CALENDAR_ID }}'
        },
{{ end }}
{{ if .Env.SPOT_OUTLOOK_CALENDAR_ID }}
        OUTLOOK: {
            CLIENT_ID: '{{ .Env.SPOT_OUTLOOK_CALENDAR_ID }}'
        },
{{ end }}
        _: ''
    },
    MEETING_DOMAINS_WHITELIST: [
        '{{ $SPOT_DOMAIN }}',
        'meet.jit.si'
    ],
    XMPP_CONFIG: {
        bosh: '{{ .Env.PUBLIC_URL }}/http-bind',
        hosts: {
            domain: '{{ .Env.XMPP_DOMAIN }}',
            muc: '{{ .Env.XMPP_MUC_DOMAIN }}'
        }
    }
};
