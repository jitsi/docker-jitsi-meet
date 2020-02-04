/* eslint-disable no-unused-vars, no-var */
{{ $XMPP_DOMAIN := .Env.XMPP_DOMAIN | default "jitsi-meet.example.com" -}}
{{ $XMPP_MUC_DOMAIN := .Env.XMPP_MUC_DOMAIN | default "conference.example.com" -}}
{{ $CONFIG_RESOLUTION := .Env.CONFIG_RESOLUTION | default "720" -}}
{{ $CONFIG_RESOLUTION_WIDTH := .Env.CONFIG_RESOLUTION_WIDTH | default "1280" -}}
{{ $CONFIG_DISABLE_SIMULCAST := .Env.CONFIG_DISABLE_SIMULCAST | default "false" -}}
{{ $CONFIG_ENABLE_REMB := .Env.CONFIG_ENABLE_REMB | default "true" -}}
{{ $CONFIG_ENABLE_TCC := .Env.CONFIG_ENABLE_TCC | default "true" -}}
{{ $ENABLE_RECORDING := .Env.ENABLE_RECORDING | default "false" | toBool -}}
{{ $CONFIG_FILE_RECORDING_SERVICE_ENABLED := .Env.CONFIG_FILE_RECORDING_SERVICE_ENABLED | default "false" | toBool -}}
{{ $CONFIG_FILE_RECORDING_SERVICE_SHARING_ENABLED := .Env.CONFIG_FILE_RECORDING_SERVICE_SHARING_ENABLED | default "false" | toBool -}}
{{ $CONFIG_EXTERNAL_CONNECT := .Env.CONFIG_EXTERNAL_CONNECT | default "false" | toBool -}}
{{ $XMPP_RECORDER_DOMAIN := .Env.XMPP_RECORDER_DOMAIN | default "recorder.example.com" -}}
{{ $CONFIG_CHROME_MIN_EXT_VERSION := .Env.CONFIG_CHROME_MIN_EXT_VERSION | default "0.1" -}}
{{ $CONFIG_ENABLE_USER_ROLES_BASED_ON_TOKEN := .Env.CONFIG_ENABLE_USER_ROLES_BASED_ON_TOKEN | default "false" -}}
{{ $CONFIG_TESTING_OCTO_PROBABILITY := .Env.CONFIG_TESTING_OCTO_PROBABILITY | default "0" -}}
{{ $CONFIG_TESTING_CAP_SCREENSHARE_BITRATE := .Env.CONFIG_TESTING_CAP_SCREENSHARE_BITRATE | default "1" -}}
{{ $ENABLE_LIPSYNC := .Env.ENABLE_LIPSYNC | default "false" | toBool -}}
{{ $ENABLE_SUBDOMAINS := .Env.ENABLE_SUBDOMAINS | default "false" | toBool -}}
{{ $ENABLE_GUESTS := .Env.ENABLE_GUESTS | default "false" | toBool -}}
{{ $ENABLE_AUTH := .Env.ENABLE_AUTH | default "false" | toBool -}}
{{ $ENABLE_TRANSCRIPTIONS := .Env.ENABLE_TRANSCRIPTIONS | default "false" | toBool -}}
{{ $CONFIG_ENABLE_STATS_ID := .Env.CONFIG_ENABLE_STATS_ID | default "false" | toBool -}}
{{ $CONFIG_OPEN_BRIDGE_CHANNEL := .Env.CONFIG_OPEN_BRIDGE_CHANNEL | default "datachannel" -}}
{{ $CONFIG_STEREO := .Env.CONFIG_STEREO | default "false" | toBool -}}
{{ $CONFIG_ENABLE_TALK_WHILE_MUTED := .Env.CONFIG_ENABLE_TALK_WHILE_MUTED | default "false" | toBool -}}
{{ $CONFIG_ENABLE_NO_AUDIO_DETECTION := .Env.CONFIG_ENABLE_NO_AUDIO_DETECTION | default "false" | toBool -}}
{{ $CONFIG_ENABLE_CALENDAR := .Env.CONFIG_ENABLE_CALENDAR | default "false" | toBool -}}
{{ $CONFIG_REQUIRE_DISPLAY_NAME := .Env.CONFIG_REQUIRE_DISPLAY_NAME | default "false" | toBool -}}
{{ $CONFIG_REQUIRE_DISPLAY_NAME := .Env.CONFIG_REQUIRE_DISPLAY_NAME | default "false" | toBool -}}
{{ $CONFIG_START_VIDEO_MUTED := .Env.CONFIG_START_VIDEO_MUTED | default 10 -}}
{{ $CONFIG_START_AUDIO_MUTED := .Env.CONFIG_START_AUDIO_MUTED | default 10 -}}
{{ $CONFIG_USE_STUN_TURN := .Env.CONFIG_USE_STUN_TURN | default "true" | toBool -}}



{{ if $ENABLE_SUBDOMAINS -}}
var subdomain = "<!--# echo var="subdomain" default="" -->";
if (subdomain) {
    subdomain = subdomain.substr(0,subdomain.length-1).split('.').join('_').toLowerCase() + '.';
}
{{ end -}}
var config = {
    // Configuration
    //

    // Alternative location for the configuration.
    // configLocation: './config.json',

    // Custom function which given the URL path should return a room name.
    // getroomnode: function (path) { return 'someprefixpossiblybasedonpath'; },

    // Connection
    //

    hosts: {
        // XMPP domain.
        domain: '{{ $XMPP_DOMAIN }}',
        {{ if $ENABLE_GUESTS -}}
        // When using authentication, domain for guest users.
        anonymousdomain: '{{ .Env.XMPP_GUEST_DOMAIN }}',
        {{ end -}}
        {{ if $ENABLE_AUTH -}}
        // Domain for authenticated users. Defaults to <domain>.
        authdomain: '{{ .Env.XMPP_DOMAIN }}',
        {{ end -}}
        // Focus component domain. Defaults to focus.<domain>.
        focus: 'focus.{{ $XMPP_DOMAIN }}',
        // XMPP MUC domain. FIXME: use XEP-0030 to discover it.
        {{ if $ENABLE_SUBDOMAINS -}}
        muc: 'conference.'+subdomain+'{{ $XMPP_DOMAIN }}'
        {{ else -}}
        muc: {{ $XMPP_MUC_DOMAIN }}'
        {{ end -}}
    },
    // BOSH URL. FIXME: use XEP-0156 to discover it.
    bosh: '{{ if .Env.CONFIG_BOSH_HOST }}https://{{ $.Env.CONFIG_BOSH_HOST }}{{ end }}/http-bind',
    {{ if .Env.ENABLE_WEBSOCKETS -}}
    websocket: 'wss://{{ if .Env.CONFIG_BOSH_HOST }}{{ .Env.CONFIG_BOSH_HOST }}{{end}}/xmpp-websocket',
    {{ end -}}

    // The name of client node advertised in XEP-0115 'c' stanza
    clientNode: 'http://jitsi.org/jitsimeet',

    // Testing / experimental features.
    testing: {
        // enable screensharing bitrate cap
        capScreenshareBitrate: {{ $CONFIG_TESTING_CAP_SCREENSHARE_BITRATE }},

        // enable octo
        octo: {
            probability: {{ $CONFIG_TESTING_OCTO_PROBABILITY }}
        },

        // Enables experimental simulcast support on Firefox.
        enableFirefoxSimulcast: false,

        // P2P test mode disables automatic switching to P2P when there are 2
        // participants in the conference.
        p2pTestMode: false

        // Enables the test specific features consumed by jitsi-meet-torture
        // testMode: false
    },

    // Disables ICE/UDP by filtering out local and remote UDP candidates in
    // signalling.
    // webrtcIceUdpDisable: false,

    // Disables ICE/TCP by filtering out local and remote TCP candidates in
    // signalling.
    // webrtcIceTcpDisable: false,


    // Media
    //

    // Audio

    // Disable measuring of audio levels.
    // disableAudioLevels: false,

    // Start the conference in audio only mode (no video is being received nor
    // sent).
    // startAudioOnly: false,

    // Every participant after the Nth will start audio muted.
    startAudioMuted: {{ $CONFIG_START_AUDIO_MUTED }},

    // Start calls with audio muted. Unlike the option above, this one is only
    // applied locally. FIXME: having these 2 options is confusing.
    // startWithAudioMuted: false,

    // Enabling it (with #params) will disable local audio output of remote
    // participants and to enable it back a reload is needed.
    // startSilent: false

    // Video

    // Sets the preferred resolution (height) for local video. Defaults to 720.
    resolution: {{ $CONFIG_RESOLUTION }},

    // w3c spec-compliant video constraints to use for video capture. Currently
    // used by browsers that return true from lib-jitsi-meet's
    // util#browser#usesNewGumFlow. The constraints are independency from
    // this config's resolution value. Defaults to requesting an ideal aspect
    // ratio of 16:9 with an ideal resolution of 720.
    constraints: {
        video: {
            aspectRatio: 16 / 9,
            height: {
                ideal: {{ $CONFIG_RESOLUTION }},
                max: {{ $CONFIG_RESOLUTION }},
                min: 180
            },
            width: {
                ideal: {{ $CONFIG_RESOLUTION_WIDTH }},
                max: {{ $CONFIG_RESOLUTION_WIDTH }},
                min: 320
            }
        }
    },

    // URL for pre-bind BOSH session setup service
{{ if $CONFIG_EXTERNAL_CONNECT -}}
    {{ if $ENABLE_SUBDOMAINS -}}
    externalConnectUrl: '//{{ if .Env.CONFIG_BOSH_HOST }}{{ .Env.CONFIG_BOSH_HOST }}{{ end }}/<!--# echo var="subdir" default="" -->http-pre-bind',
    {{ else -}}
    externalConnectUrl: '//{{ if .Env.CONFIG_BOSH_HOST }}{{ .Env.CONFIG_BOSH_HOST }}{{ end }}/http-pre-bind',
    {{ end -}}
{{ end -}}

    // Enable / disable simulcast support.
    disableSimulcast: {{ $CONFIG_DISABLE_SIMULCAST }},

    // Enable / disable layer suspension.  If enabled, endpoints whose HD
    // layers are not in use will be suspended (no longer sent) until they
    // are requested again.
    // enableLayerSuspension: false,

    // Suspend sending video if bandwidth estimation is too low. This may cause
    // problems with audio playback. Disabled until these are fixed.
    disableSuspendVideo: true,

    // Every participant after the Nth will start video muted.
    startVideoMuted: {{ $CONFIG_START_VIDEO_MUTED }},

    // Start calls with video muted. Unlike the option above, this one is only
    // applied locally. FIXME: having these 2 options is confusing.
    // startWithVideoMuted: false,

    // If set to true, prefer to use the H.264 video codec (if supported).
    // Note that it's not recommended to do this because simulcast is not
    // supported when  using H.264. For 1-to-1 calls this setting is enabled by
    // default and can be toggled in the p2p section.
    // preferH264: true,

    // If set to true, disable H.264 video codec by stripping it out of the
    // SDP.
    // disableH264: false,

    // Desktop sharing

    // The ID of the jidesha extension for Chrome.
    {{ if .Env.CONFIG_CHROME_EXT_ID }}
    desktopSharingChromeExtId: '{{.Env.CONFIG_CHROME_EXT_ID}}',
    {{ else }}
    desktopSharingChromeExtId: null,
    {{ end }}
    // Whether desktop sharing should be disabled on Chrome.
    // desktopSharingChromeDisabled: false,

    // The media sources to use when using screen sharing with the Chrome
    // extension.
    desktopSharingChromeSources: [ 'screen', 'window', 'tab' ],

    // Required version of Chrome extension
    desktopSharingChromeMinExtVersion: '{{ $CONFIG_CHROME_MIN_EXT_VERSION }}',

    // Whether desktop sharing should be disabled on Firefox.
    // desktopSharingFirefoxDisabled: false,

    // Optional desktop sharing frame rate options. Default value: min:5, max:5.
    // desktopSharingFrameRate: {
    //     min: 5,
    //     max: 5
    // },

    // Try to start calls with screen-sharing instead of camera video.
    // startScreenSharing: false,

    // Recording

    // Whether to enable file recording or not.
    {{ if $ENABLE_RECORDING }}
    hiddenDomain: '{{ $XMPP_RECORDER_DOMAIN }}',
    fileRecordingsEnabled: true,

    // Whether to enable live streaming or not.
    liveStreamingEnabled: true,
    {{ if .Env.CONFIG_DROPBOX_APPKEY }}
    // Enable the dropbox integration.
    dropbox: {
        // Specify your app key here.
        appKey: '{{ .Env.CONFIG_DROPBOX_APPKEY }}',
    {{ if .Env.CONFIG_DROPBOX_REDIRECT_URI }}
        // A URL to redirect the user to, after authenticating
        // by default uses:
        // 'https://jitsi-meet.example.com/static/oauth.html'
        redirectURI: '{{ .Env.CONFIG_DROPBOX_REDIRECT_URI }}'
    {{ end }}
    },
    {{ end }}
    {{ if $CONFIG_FILE_RECORDING_SERVICE_ENABLED }}
    // When integrations like dropbox are enabled only that will be shown,
    // by enabling fileRecordingsServiceEnabled, we show both the integrations
    // and the generic recording service (its configuration and storage type
    // depends on jibri configuration)
    fileRecordingsServiceEnabled: true,
    {{ end }}
    {{ if $CONFIG_FILE_RECORDING_SERVICE_SHARING_ENABLED }}
    // Whether to show the possibility to share file recording with other people
    // (e.g. meeting participants), based on the actual implementation
    // on the backend.
    fileRecordingsServiceSharingEnabled: true,
    {{ end }}
    {{ end }}

    {{ if $ENABLE_TRANSCRIPTIONS }}
    // Transcription (in interface_config,
    // subtitles and buttons can be configured)
    transcribingEnabled: true,
    {{ end }}

    // Misc

    // Default value for the channel "last N" attribute. -1 for unlimited.
    channelLastN: -1,

    // Disables or enables RTX (RFC 4588) (defaults to false).
    // disableRtx: false,

    // Disables or enables TCC (the default is in Jicofo and set to true)
    // (draft-holmer-rmcat-transport-wide-cc-extensions-01). This setting
    // affects congestion control, it practically enables send-side bandwidth
    // estimations.
    enableTcc:  {{ $CONFIG_ENABLE_TCC }},

    // Disables or enables REMB (the default is in Jicofo and set to false)
    // (draft-alvestrand-rmcat-remb-03). This setting affects congestion
    // control, it practically enables recv-side bandwidth estimations. When
    // both TCC and REMB are enabled, TCC takes precedence. When both are
    // disabled, then bandwidth estimations are disabled.
    enableRemb: {{ $CONFIG_ENABLE_REMB }},

    // Defines the minimum number of participants to start a call (the default
    // is set in Jicofo and set to 2).
    // minParticipants: 2,

    {{ if $CONFIG_USE_STUN_TURN -}}
    // Use XEP-0215 to fetch STUN and TURN servers.
    useStunTurn: true,
    {{ else -}}
    // Skip STUN and TURN.
    useStunTurn: false,
    {{ end -}}

    // Enable IPv6 support.
    {{ if .Env.CONFIG_USE_IPV6 -}}
    useIPv6: true,
    {{ end -}}

    // Enables / disables a data communication channel with the Videobridge.
    // Values can be 'datachannel', 'websocket', true (treat it as
    // 'datachannel'), undefined (treat it as 'datachannel') and false (don't
    // open any channel).
    // openBridgeChannel: true,
    openBridgeChannel: '{{ $CONFIG_OPEN_BRIDGE_CHANNEL }}', // One of true, 'datachannel', or 'websocket'


    // UI
    //

    // Use display name as XMPP nickname.
    // useNicks: false,

    {{ if $CONFIG_REQUIRE_DISPLAY_NAME }}
    // Require users to always specify a display name.
    requireDisplayName: true,
    {{ else }}
    // No need to specify a display name.
    requireDisplayName: false,
    {{ end }}

    // Whether to use a welcome page or not. In case it's false a random room
    // will be joined when no room is specified.
    enableWelcomePage: true,

    // Enabling the close page will ignore the welcome page redirection when
    // a call is hangup.
    // enableClosePage: false,

    // Disable hiding of remote thumbnails when in a 1-on-1 conference call.
    // disable1On1Mode: false,

    // Default language for the user interface.
    // defaultLanguage: 'en',

    // If true all users without a token will be considered guests and all users
    // with token will be considered non-guests. Only guests will be allowed to
    // edit their profile.
    enableUserRolesBasedOnToken: {{ $CONFIG_ENABLE_USER_ROLES_BASED_ON_TOKEN }},

    // Whether or not some features are checked based on token.
    // enableFeaturesBasedOnToken: false,

    // Enable lock room for all moderators, even when userRolesBasedOnToken is enabled and participants are guests.
    // lockRoomGuestEnabled: false,

    // When enabled the password used for locking a room is restricted to up to the number of digits specified
    // roomPasswordNumberOfDigits: 10,
    // default: roomPasswordNumberOfDigits: false,

    // Message to show the users. Example: 'The service will be down for
    // maintenance at 01:00 AM GMT,
    // noticeMessage: '',

    // Enables calendar integration, depends on googleApiApplicationClientID
    // and microsoftApiApplicationClientID
{{ if $CONFIG_ENABLE_CALENDAR }}
    enableCalendarIntegration: true,
{{ end }}

    // Stats
    //

    // Whether to enable stats collection or not in the TraceablePeerConnection.
    // This can be useful for debugging purposes (post-processing/analysis of
    // the webrtc stats) as it is done in the jitsi-meet-torture bandwidth
    // estimation tests.
    // gatherStats: false,

{{ if .Env.CONFIG_CALLSTATS_ID }}
    // To enable sending statistics to callstats.io you must provide the
    // Application ID and Secret.
    callStatsID: '{{ .Env.CONFIG_CALLSTATS_ID }}',
{{ end }}
{{ if .Env.CONFIG_CALLSTATS_ID }}
    callStatsSecret: '{{ .Env.CONFIG_CALLSTATS_SECRET }}',
{{ end }}
{{ if $CONFIG_ENABLE_STATS_ID }}
    // enables callstatsUsername to be reported as statsId and used
    // by callstats as repoted remote id
    enableStatsID: true,
{{ end }}
    // enables sending participants display name to callstats
    // enableDisplayNameInStats: false


    // Privacy
    //

    // If third party requests are disabled, no other server will be contacted.
    // This means avatars will be locally generated and callstats integration
    // will not function.
    // disableThirdPartyRequests: false,


    // Peer-To-Peer mode: used (if enabled) when there are just 2 participants.
    //

    p2p: {
        // Enables peer to peer mode. When enabled the system will try to
        // establish a direct connection when there are exactly 2 participants
        // in the room. If that succeeds the conference will stop sending data
        // through the JVB and use the peer to peer connection instead. When a
        // 3rd participant joins the conference will be moved back to the JVB
        // connection.
        enabled: true,

        // Use XEP-0215 to fetch STUN and TURN servers.
        {{ if .Env.CONFIG_P2P_STUNTURN }}
        useStunTurn: true,
        {{ end }}
        // The STUN servers that will be used in the peer to peer connections
        stunServers: [
            { urls: 'stun:stun.l.google.com:19302' },
            { urls: 'stun:stun1.l.google.com:19302' },
            { urls: 'stun:stun2.l.google.com:19302' }
        ],

        // Sets the ICE transport policy for the p2p connection. At the time
        // of this writing the list of possible values are 'all' and 'relay',
        // but that is subject to change in the future. The enum is defined in
        // the WebRTC standard:
        // https://www.w3.org/TR/webrtc/#rtcicetransportpolicy-enum.
        // If not set, the effective value is 'all'.
        // iceTransportPolicy: 'all',

        // If set to true, it will prefer to use H.264 for P2P calls (if H.264
        // is supported).
        preferH264: true

        // If set to true, disable H.264 video codec by stripping it out of the
        // SDP.
        // disableH264: false,

        // How long we're going to wait, before going back to P2P after the 3rd
        // participant has left the conference (to filter out page reload).
        // backToP2PDelay: 5
    },

    analytics: {
        // The Google Analytics Tracking ID:
        {{ if .Env.CONFIG_GOOGLE_ANALYTICS_ID }}
        googleAnalyticsTrackingId: '{{ .Env.CONFIG_GOOGLE_ANALYTICS_ID }}',
        {{ end }}
        // The Amplitude APP Key:
        // amplitudeAPPKey: '<APP_KEY>'
        {{ if .Env.CONFIG_AMPLITUDE_ID }}
        amplitudeAPPKey: '{{ .Env.CONFIG_AMPLITUDE_ID }}',
        {{ end }}
        {{ if .Env.CONFIG_ANALYTICS_WHITELISTED_EVENTS }}
        whiteListedEvents: [ '{{ join "','" (splitList "," .Env.CONFIG_ANALYTICS_WHITELISTED_EVENTS) }}' ],
        {{ end }}
        // Array of script URLs to load as lib-jitsi-meet "analytics handlers".
        {{ if .Env.CONFIG_ANALYTICS_SCRIPT_URLS }}
        scriptURLs: [ '{{ join "','" (splitList "," .Env.CONFIG_ANALYTICS_SCRIPT_URLS) }}' ],
        {{ end }}
        // scriptURLs: [
        //      "libs/analytics-ga.min.js", // google-analytics
        //      "https://example.com/my-custom-analytics.js"
        // ],
    },

    // Information about the jitsi-meet instance we are connecting to, including
    // the user region as seen by the server.
    // deploymentInfo: {
        // shard: "shard1",
        // region: "europe",
        // userRegion: "asia"
    // }
    deploymentInfo: {
        environment: '{{ .Env.CONFIG_DEPLOYMENTINFO_ENVIRONMENT }}',
        envType: '{{ .Env.CONFIG_DEPLOYMENTINFO_ENVIRONMENT_TYPE }}',
        userRegion: '<!--# echo var="http_x_proxy_region" default="" -->',
    },

    // Local Recording
    //

    // localRecording: {
    // Enables local recording.
    // Additionally, 'localrecording' (all lowercase) needs to be added to
    // TOOLBAR_BUTTONS in interface_config.js for the Local Recording
    // button to show up on the toolbar.
    //
    //     enabled: true,
    //

    // The recording format, can be one of 'ogg', 'flac' or 'wav'.
    //     format: 'flac'
    //

    // }

    // Options related to end-to-end (participant to participant) ping.
    // e2eping: {
    //   // The interval in milliseconds at which pings will be sent.
    //   // Defaults to 10000, set to <= 0 to disable.
    //   pingInterval: 10000,
    //
    //   // The interval in milliseconds at which analytics events
    //   // with the measured RTT will be sent. Defaults to 60000, set
    //   // to <= 0 to disable.
    //   analyticsInterval: 60000,
    //   }

    // If set, will attempt to use the provided video input device label when
    // triggering a screenshare, instead of proceeding through the normal flow
    // for obtaining a desktop stream.
    // NOTE: This option is experimental and is currently intended for internal
    // use only.
    // _desktopSharingSourceDevice: 'sample-id-or-label'

    // If true, any checks to handoff to another application will be prevented
    // and instead the app will continue to display in the current browser.
    // disableDeepLinking: false

    // A property to disable the right click context menu for localVideo
    // the menu has option to flip the locally seen video for local presentations
    // disableLocalVideoFlip: false


    // Lipsync hack in jicofo, may not be safe
    {{ if $ENABLE_LIPSYNC -}}
    enableLipSync: true,
    {{ end }}
    {{ if .Env.CONFIG_START_BITRATE -}}
    startBitrate: '{{ .Env.CONFIG_START_BITRATE }}',
    {{ end }}
    {{ if $CONFIG_STEREO -}}
    stereo: true,
    {{ end }}
    {{ if $CONFIG_ENABLE_TALK_WHILE_MUTED -}}
    enableTalkWhileMuted: true,
    {{ end }}
    {{ if $CONFIG_ENABLE_NO_AUDIO_DETECTION -}}
    enableNoAudioDetection: true,
    {{ end }}
    {{ if .Env.CONFIG_GOOGLE_API_APP_CLIENT_ID -}}
    googleApiApplicationClientID: '{{ .Env.CONFIG_GOOGLE_API_APP_CLIENT_ID }}',
    {{ end }}
    {{ if .Env.CONFIG_MICROSOFT_API_APP_CLIENT_ID -}}
    microsoftApiApplicationClientID: '{{ .Env.CONFIG_MICROSOFT_API_APP_CLIENT_ID }}',
    {{ end }}
    {{ if .Env.CONFIG_CALLSTATS_CUSTOM_SCRIPT_URL -}}
    callStatsCustomScriptUrl: '{{ .Env.CONFIG_CALLSTATS_CUSTOM_SCRIPT_URL }}',
    {{ end }}
    {{ if .Env.ETHERPAD_URL_BASE }}
    etherpad_base: '{{ .Env.ETHERPAD_URL_BASE }}',
    {{ end }}
    {{ if .Env.CONFIG_DIALIN_NUMBERS_URL }}
    dialInNumbersUrl: '{{ .Env.CONFIG_DIALIN_NUMBERS_URL }}',
    {{ end }}
    {{ if .Env.CONFIG_CONFCODE_URL }}
    dialInConfCodeUrl: '{{ .Env.CONFIG_CONFCODE_URL }}',
    {{ end }}
    {{ if .Env.CONFIG_DIALOUT_CODES_URL }}
    dialOutCodesUrl: '{{ .Env.CONFIG_DIALOUT_CODES_URL }}',
    {{ end }}
    {{ if .Env.CONFIG_DIALOUT_AUTH_URL }}
    dialOutAuthUrl: '{{ .Env.CONFIG_DIALOUT_AUTH_URL }}',
    {{ end }}
    {{ if .Env.CONFIG_PEOPLE_SEARCH_URL }}
    peopleSearchUrl: '{{ .Env.CONFIG_PEOPLE_SEARCH_URL }}',
    {{ end }}
    {{ if .Env.CONFIG_PEOPLE_SEARCH_URL }}
    peopleSearchQueryTypes: ['user','conferenceRooms'],
    {{ end }}
    {{ if .Env.CONFIG_INVITE_SERVICE_URL }}
    inviteServiceUrl: '{{ .Env.CONFIG_INVITE_SERVICE_URL }}',
    {{ end }}
    {{ if .Env.CONFIG_INVITE_SERVICE_CALLFLOWS_URL }}
    inviteServiceCallFlowsUrl: '{{ .Env.CONFIG_INVITE_SERVICE_CALLFLOWS_URL }}',
    {{ end }}

    {{ if .Env.CONFIG_CHROME_EXTENSION_BANNER_JSON }}
    chromeExtensionBanner: {{ .Env.CONFIG_CHROME_EXTENSION_BANNER_JSON }},
    {{ end }}
    // List of undocumented settings used in jitsi-meet
    /**
     _immediateReloadThreshold
     autoRecord
     autoRecordToken
     debug
     debugAudioLevels
     disableRemoteControl
     displayJids
     
     firefox_fake_device
     iAmRecorder
     iAmSipGateway
     tokenAuthUrl
     */

    // List of undocumented settings used in lib-jitsi-meet
    /**
     _peerConnStatusOutOfLastNTimeout
     _peerConnStatusRtcMuteTimeout
     abTesting
     avgRtpStatsN
     callStatsConfIDNamespace
     desktopSharingSources
     disableAEC
     disableAGC
     disableAP
     disableHPF
     disableNS
     forceJVB121Ratio
     hiddenDomain
     ignoreStartMuted
     nick
     */

};

/* eslint-enable no-unused-vars, no-var */
