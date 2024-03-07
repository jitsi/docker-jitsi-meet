{{ $DEPLOYMENTINFO_USERREGION := .Env.DEPLOYMENTINFO_USERREGION | default "" -}}
{{ $ENABLE_AUDIO_PROCESSING := .Env.ENABLE_AUDIO_PROCESSING | default "true" | toBool -}}
{{ $ENABLE_BREAKOUT_ROOMS := .Env.ENABLE_BREAKOUT_ROOMS | default "true" | toBool -}}
{{ $ENABLE_CALENDAR := .Env.ENABLE_CALENDAR | default "false" | toBool -}}
{{ $ENABLE_FILE_RECORDING_SHARING := .Env.ENABLE_FILE_RECORDING_SHARING | default "false" | toBool -}}
{{ $ENABLE_NO_AUDIO_DETECTION := .Env.ENABLE_NO_AUDIO_DETECTION | default "true" | toBool -}}
{{ $ENABLE_P2P := .Env.ENABLE_P2P | default "true" | toBool -}}
{{ $ENABLE_PREJOIN_PAGE := .Env.ENABLE_PREJOIN_PAGE | default "true" | toBool -}}
{{ $ENABLE_WELCOME_PAGE := .Env.ENABLE_WELCOME_PAGE | default "true" | toBool -}}
{{ $ENABLE_CLOSE_PAGE := .Env.ENABLE_CLOSE_PAGE | default "false" | toBool -}}
{{ $ENABLE_RECORDING := .Env.ENABLE_RECORDING | default "false" | toBool -}}
{{ $ENABLE_SERVICE_RECORDING := .Env.ENABLE_SERVICE_RECORDING | default ($ENABLE_RECORDING | printf "%t") | toBool -}}
{{ $ENABLE_LIVESTREAMING := .Env.ENABLE_LIVESTREAMING | default "false" | toBool -}}
{{ $ENABLE_LIVESTREAMING_DATA_PRIVACY_LINK := .Env.ENABLE_LIVESTREAMING_DATA_PRIVACY_LINK | default "https://policies.google.com/privacy" -}}
{{ $ENABLE_LIVESTREAMING_HELP_LINK := .Env.ENABLE_LIVESTREAMING_HELP_LINK | default "https://jitsi.org/live" -}}
{{ $ENABLE_LIVESTREAMING_TERMS_LINK := .Env.ENABLE_LIVESTREAMING_TERMS_LINK | default "https://www.youtube.com/t/terms" -}}
{{ $ENABLE_LIVESTREAMING_VALIDATOR_REGEXP_STRING := .Env.ENABLE_LIVESTREAMING_VALIDATOR_REGEXP_STRING | default "^(?:[a-zA-Z0-9]{4}(?:-(?!$)|$)){4}" -}}
{{ $ENABLE_REMB := .Env.ENABLE_REMB | default "true" | toBool -}}
{{ $ENABLE_REQUIRE_DISPLAY_NAME := .Env.ENABLE_REQUIRE_DISPLAY_NAME | default "false" | toBool -}}
{{ $ENABLE_SIMULCAST := .Env.ENABLE_SIMULCAST | default "true" | toBool -}}
{{ $ENABLE_STEREO := .Env.ENABLE_STEREO | default "false" | toBool -}}
{{ $ENABLE_OPUS_RED := .Env.ENABLE_OPUS_RED | default "false" | toBool -}}
{{ $ENABLE_TALK_WHILE_MUTED := .Env.ENABLE_TALK_WHILE_MUTED | default "false" | toBool -}}
{{ $ENABLE_TCC := .Env.ENABLE_TCC | default "true" | toBool -}}
{{ $ENABLE_TRANSCRIPTIONS := .Env.ENABLE_TRANSCRIPTIONS | default "false" | toBool -}}
{{ $TRANSLATION_LANGUAGES := .Env.TRANSLATION_LANGUAGES | default "[]" -}}
{{ $TRANSLATION_LANGUAGES_HEAD := .Env.TRANSLATION_LANGUAGES_HEAD | default "['en']" -}}
{{ $USE_APP_LANGUAGE := .Env.USE_APP_LANGUAGE | default "true" | toBool -}}
{{ $PREFERRED_LANGUAGE := .Env.PREFERRED_LANGUAGE | default "en-US" -}}
{{ $DISABLE_START_FOR_ALL := .Env.DISABLE_START_FOR_ALL | default "false" | toBool -}}
{{ $AUTO_CAPTION_ON_RECORD := .Env.AUTO_CAPTION_ON_RECORD | default "false" | toBool -}}
{{ $ENABLE_JAAS_COMPONENTS := .Env.ENABLE_JAAS_COMPONENTS | default "0" | toBool }}
{{ $HIDE_PREJOIN_DISPLAY_NAME := .Env.HIDE_PREJOIN_DISPLAY_NAME | default "false" | toBool -}}
{{ $PUBLIC_URL := .Env.PUBLIC_URL | default "https://localhost:8443" -}}
{{ $RESOLUTION := .Env.RESOLUTION | default "720" -}}
{{ $RESOLUTION_MIN := .Env.RESOLUTION_MIN | default "180" -}}
{{ $RESOLUTION_WIDTH := .Env.RESOLUTION_WIDTH | default "1280" -}}
{{ $RESOLUTION_WIDTH_MIN := .Env.RESOLUTION_WIDTH_MIN | default "320" -}}
{{ $START_AUDIO_ONLY := .Env.START_AUDIO_ONLY | default "false" | toBool -}}
{{ $START_AUDIO_MUTED := .Env.START_AUDIO_MUTED | default 10 -}}
{{ $START_WITH_AUDIO_MUTED := .Env.START_WITH_AUDIO_MUTED | default "false" | toBool -}}
{{ $START_SILENT := .Env.START_SILENT | default "false" | toBool -}}
{{ $DISABLE_AUDIO_LEVELS := .Env.DISABLE_AUDIO_LEVELS | default "false" | toBool -}}
{{ $ENABLE_NOISY_MIC_DETECTION := .Env.ENABLE_NOISY_MIC_DETECTION | default "true" | toBool -}}
{{ $START_VIDEO_MUTED := .Env.START_VIDEO_MUTED | default 10 -}}
{{ $START_WITH_VIDEO_MUTED := .Env.START_WITH_VIDEO_MUTED | default "false" | toBool -}}
{{ $DESKTOP_SHARING_FRAMERATE_AUTO := .Env.DESKTOP_SHARING_FRAMERATE_AUTO | default "true" | toBool -}}
{{ $DESKTOP_SHARING_FRAMERATE_MIN := .Env.DESKTOP_SHARING_FRAMERATE_MIN | default 5 -}}
{{ $DESKTOP_SHARING_FRAMERATE_MAX := .Env.DESKTOP_SHARING_FRAMERATE_MAX | default 5 -}}
{{ $XMPP_DOMAIN := .Env.XMPP_DOMAIN | default "meet.jitsi" -}}
{{ $XMPP_RECORDER_DOMAIN := .Env.XMPP_RECORDER_DOMAIN | default "recorder.meet.jitsi" -}}
{{ $DISABLE_DEEP_LINKING  := .Env.DISABLE_DEEP_LINKING | default "false" | toBool -}}
{{ $DISABLE_POLLS := .Env.DISABLE_POLLS | default "false" | toBool -}}
{{ $DISABLE_REACTIONS := .Env.DISABLE_REACTIONS | default "false" | toBool -}}
{{ $DISABLE_REMOTE_VIDEO_MENU := .Env.DISABLE_REMOTE_VIDEO_MENU | default "false" | toBool -}}
{{ $DISABLE_PRIVATE_CHAT:= .Env.DISABLE_PRIVATE_CHAT | default "false" | toBool -}}
{{ $DISABLE_KICKOUT := .Env.DISABLE_KICKOUT | default "false" | toBool -}}
{{ $DISABLE_GRANT_MODERATOR := .Env.DISABLE_GRANT_MODERATOR | default "false" | toBool -}}
{{ $ENABLE_E2EPING := .Env.ENABLE_E2EPING | default "false" | toBool -}}
{{ $DISABLE_LOCAL_RECORDING := .Env.DISABLE_LOCAL_RECORDING | default "false" | toBool -}}
{{ $ENABLE_LOCAL_RECORDING_NOTIFY_ALL_PARTICIPANT := .Env.ENABLE_LOCAL_RECORDING_NOTIFY_ALL_PARTICIPANT | default "false" | toBool -}}
{{ $ENABLE_LOCAL_RECORDING_SELF_START := .Env.ENABLE_LOCAL_RECORDING_SELF_START | default "false" | toBool -}}
{{ $DISABLE_PROFILE := .Env.DISABLE_PROFILE | default "false" | toBool -}}
{{ $ROOM_PASSWORD_DIGITS := .Env.ROOM_PASSWORD_DIGITS | default "false" -}}
{{ $WHITEBOARD_COLLAB_SERVER_PUBLIC_URL := .Env.WHITEBOARD_COLLAB_SERVER_PUBLIC_URL | default "" -}}
{{ $WHITEBOARD_ENABLED := .Env.WHITEBOARD_ENABLED | default "false" | toBool -}}
{{ $TESTING_AV1_SUPPORT := .Env.TESTING_AV1_SUPPORT | default "false" | toBool -}}

// Video configuration.
//

config.resolution = {{ $RESOLUTION }};
config.constraints = {
    video: {
        height: { ideal: {{ $RESOLUTION }}, max: {{ $RESOLUTION }}, min: {{ $RESOLUTION_MIN }} },
        width: { ideal: {{ $RESOLUTION_WIDTH }}, max: {{ $RESOLUTION_WIDTH }}, min: {{ $RESOLUTION_WIDTH_MIN }}},
    }
};

{{ if not $ENABLE_SIMULCAST -}}
config.disableSimulcast = true;
{{ end -}}
config.startVideoMuted = {{ $START_VIDEO_MUTED }};
config.startWithVideoMuted = {{ $START_WITH_VIDEO_MUTED }};

config.flags = {
    sourceNameSignaling: true,
    sendMultipleVideoStreams: true,
    receiveMultipleVideoStreams: true
};

// ScreenShare Configuration.
//

{{ if not $DESKTOP_SHARING_FRAMERATE_AUTO -}}
config.desktopSharingFrameRate = {
    min: {{ $DESKTOP_SHARING_FRAMERATE_MIN }},
    max: {{ $DESKTOP_SHARING_FRAMERATE_MAX }}
};
{{ end -}}

// Audio configuration.
//

config.enableNoAudioDetection = {{ $ENABLE_NO_AUDIO_DETECTION }};
config.enableTalkWhileMuted = {{ $ENABLE_TALK_WHILE_MUTED }};
config.disableAP = {{ not $ENABLE_AUDIO_PROCESSING }};

config.audioQuality = {
    stereo: {{ $ENABLE_STEREO }}
};

{{ if .Env.AUDIO_QUALITY_OPUS_BITRATE -}}
config.audioQuality.opusMaxAverageBitrate = '{{ .Env.AUDIO_QUALITY_OPUS_BITRATE }}';
{{ end -}}

config.startAudioOnly = {{ $START_AUDIO_ONLY }};
config.startAudioMuted = {{ $START_AUDIO_MUTED }};
config.startWithAudioMuted = {{ $START_WITH_AUDIO_MUTED }};
config.startSilent = {{ $START_SILENT }};
config.enableOpusRed = {{ $ENABLE_OPUS_RED }};
config.disableAudioLevels = {{ $DISABLE_AUDIO_LEVELS }};
config.enableNoisyMicDetection = {{ $ENABLE_NOISY_MIC_DETECTION }};


// Peer-to-Peer options.
//

config.p2p = {
    enabled: {{ $ENABLE_P2P }}
};


// Breakout Rooms
//

config.hideAddRoomButton = {{ $ENABLE_BREAKOUT_ROOMS | not }};


// Etherpad
//

{{ if .Env.ETHERPAD_PUBLIC_URL -}}
config.etherpad_base = '{{ .Env.ETHERPAD_PUBLIC_URL }}';
{{ else if .Env.ETHERPAD_URL_BASE -}}
config.etherpad_base = '{{ $PUBLIC_URL }}/etherpad/p/';
{{ end -}}


// Recording.
//

{{ if $ENABLE_RECORDING  -}}

config.hiddenDomain = '{{ $XMPP_RECORDER_DOMAIN }}';

config.recordingService = {
    // Whether to enable file recording or not using the "service" defined by the finalizer in Jibri
    enabled: {{ $ENABLE_SERVICE_RECORDING }},

    // Whether to show the possibility to share file recording with other people
    // (e.g. meeting participants), based on the actual implementation
    // on the backend.
    sharingEnabled: {{ $ENABLE_FILE_RECORDING_SHARING }}
};

// Live streaming configuration.
config.liveStreaming = {
    enabled: {{ $ENABLE_LIVESTREAMING }},
    dataPrivacyLink: '{{ $ENABLE_LIVESTREAMING_DATA_PRIVACY_LINK }}',
    helpLink: '{{ $ENABLE_LIVESTREAMING_HELP_LINK }}',
    termsLink: '{{ $ENABLE_LIVESTREAMING_TERMS_LINK }}',
    validatorRegExpString: '{{ $ENABLE_LIVESTREAMING_VALIDATOR_REGEXP_STRING }}'
};


{{ if .Env.DROPBOX_APPKEY -}}
// Enable the dropbox integration.
config.dropbox = {
    appKey: '{{ .Env.DROPBOX_APPKEY }}'
};

{{ if .Env.DROPBOX_REDIRECT_URI -}}
// A URL to redirect the user to, after authenticating
// by default uses:
// 'https://jitsi-meet.example.com/static/oauth.html'
config.dropbox.redirectURI = '{{ .Env.DROPBOX_REDIRECT_URI }}';
{{ end -}}
{{ end -}}

{{ end -}}

// Local recording configuration.
config.localRecording = {
    disable: {{ $DISABLE_LOCAL_RECORDING }},
    notifyAllParticipants: {{ $ENABLE_LOCAL_RECORDING_NOTIFY_ALL_PARTICIPANT }},
    disableSelfRecording: {{ $ENABLE_LOCAL_RECORDING_SELF_START }}
};


// Analytics.
//

config.analytics = {};

{{ if .Env.AMPLITUDE_ID -}}
// The Amplitude APP Key:
config.analytics.amplitudeAPPKey = '{{ .Env.AMPLITUDE_ID }}';
{{ end -}}

{{ if .Env.GOOGLE_ANALYTICS_ID -}}
// The Google Analytics Tracking ID:
config.analytics.googleAnalyticsTrackingId = '{{ .Env.GOOGLE_ANALYTICS_ID }}';
{{ end -}}

{{ if .Env.MATOMO_ENDPOINT -}}
// Matomo endpoint:
config.analytics.matomoEndpoint = '{{ .Env.MATOMO_ENDPOINT }}';
{{ end -}}

{{ if .Env.MATOMO_SITE_ID -}}
// Matomo site ID:
config.analytics.matomoSiteID = '{{ .Env.MATOMO_SITE_ID }}';
{{ end -}}

{{ if .Env.ANALYTICS_SCRIPT_URLS -}}
// Array of script URLs to load as lib-jitsi-meet "analytics handlers".
config.analytics.scriptURLs = [ '{{ join "','" (splitList "," .Env.ANALYTICS_SCRIPT_URLS) }}' ];
{{ end -}}

{{ if .Env.ANALYTICS_WHITELISTED_EVENTS -}}
config.analytics.whiteListedEvents = [ '{{ join "','" (splitList "," .Env.ANALYTICS_WHITELISTED_EVENTS) }}' ];
{{ end -}}


// Dial in/out services.
//

{{ if $ENABLE_JAAS_COMPONENTS }}
config.dialInConfCodeUrl = 'https://conference-mapper.jitsi.net/v1/access';
config.dialInNumbersUrl = 'https://conference-mapper.jitsi.net/v1/access/dids';
{{ else }}
{{ if .Env.CONFCODE_URL -}}
config.dialInConfCodeUrl = '{{ .Env.CONFCODE_URL }}';
{{ end -}}
{{ if .Env.DIALIN_NUMBERS_URL -}}
config.dialInNumbersUrl = '{{ .Env.DIALIN_NUMBERS_URL }}';
{{ end -}}
{{ end -}}

{{ if .Env.DIALOUT_AUTH_URL -}}
config.dialOutAuthUrl = '{{ .Env.DIALOUT_AUTH_URL }}';
{{ end -}}

{{ if .Env.DIALOUT_CODES_URL -}}
config.dialOutCodesUrl = '{{ .Env.DIALOUT_CODES_URL }}';
{{ end -}}


// Calendar service integration.
//

config.enableCalendarIntegration = {{ $ENABLE_CALENDAR }};

{{ if .Env.GOOGLE_API_APP_CLIENT_ID -}}
config.googleApiApplicationClientID = '{{ .Env.GOOGLE_API_APP_CLIENT_ID }}';
{{ end -}}

{{ if .Env.MICROSOFT_API_APP_CLIENT_ID -}}
config.microsoftApiApplicationClientID = '{{ .Env.MICROSOFT_API_APP_CLIENT_ID }}';
{{ end -}}


// Invitation service.
//

{{ if .Env.INVITE_SERVICE_URL -}}
config.inviteServiceUrl = '{{ .Env.INVITE_SERVICE_URL }}';
{{ end -}}

{{ if .Env.PEOPLE_SEARCH_URL -}}
config.peopleSearchUrl = '{{ .Env.PEOPLE_SEARCH_URL }}';
config.peopleSearchQueryTypes = ['user','conferenceRooms'];
{{ end -}}


// Miscellaneous.
//

// Prejoin page.
config.prejoinConfig = {
    enabled: {{ $ENABLE_PREJOIN_PAGE }},

    // Hides the participant name editing field in the prejoin screen.
    hideDisplayName: {{ $HIDE_PREJOIN_DISPLAY_NAME }}
};

// List of buttons to hide from the extra join options dropdown on prejoin screen.
{{ if .Env.HIDE_PREJOIN_EXTRA_BUTTONS -}}
config.prejoinConfig.hideExtraJoinButtons = [ '{{ join "','" (splitList "," .Env.HIDE_PREJOIN_EXTRA_BUTTONS) }}' ];
{{ end -}}

// Welcome page.
config.welcomePage = {
    disabled: {{ not $ENABLE_WELCOME_PAGE }}
};

// Close page.
config.enableClosePage = {{ $ENABLE_CLOSE_PAGE }};

// Default language.
{{ if .Env.DEFAULT_LANGUAGE -}}
config.defaultLanguage = '{{ .Env.DEFAULT_LANGUAGE }}';
{{ end -}}

// Require users to always specify a display name.
config.requireDisplayName = {{ $ENABLE_REQUIRE_DISPLAY_NAME }};

// Chrome extension banner.
{{ if .Env.CHROME_EXTENSION_BANNER_JSON -}}
config.chromeExtensionBanner = {{ .Env.CHROME_EXTENSION_BANNER_JSON }};
{{ end -}}

// Disables profile and the edit of all fields from the profile settings (display name and email)
config.disableProfile = {{ $DISABLE_PROFILE }};

// Room password (false for anything, number for max digits)
{{ if $ENABLE_JAAS_COMPONENTS -}}
config.roomPasswordNumberOfDigits = 10;
{{ else -}}
config.roomPasswordNumberOfDigits = {{ $ROOM_PASSWORD_DIGITS }};
{{ end -}}

// Advanced.
//

{{ if not $ENABLE_REMB -}}
config.enableRemb = false;
{{ end -}}
{{ if not $ENABLE_TCC -}}
config.enableTcc = false;
{{ end -}}


// Transcriptions (subtitles and buttons can be configured in interface_config)
config.transcription = {
    enabled: {{ $ENABLE_TRANSCRIPTIONS }},
    translationLanguages: {{ $TRANSLATION_LANGUAGES }},
    translationLanguagesHead: {{ $TRANSLATION_LANGUAGES_HEAD }},
    useAppLanguage: {{ $USE_APP_LANGUAGE }},
    preferredLanguage: '{{ $PREFERRED_LANGUAGE }}',
    disableStartForAll: {{ $DISABLE_START_FOR_ALL }},
    autoCaptionOnRecord: {{ $AUTO_CAPTION_ON_RECORD }},
};

// Dynamic branding
{{ if .Env.DYNAMIC_BRANDING_URL -}}
// External API url used to receive branding specific information.
config.dynamicBrandingUrl = '{{ .Env.DYNAMIC_BRANDING_URL }}';
{{ else if .Env.BRANDING_DATA_URL  -}}
config.brandingDataUrl = '{{ .Env.BRANDING_DATA_URL }}';
{{ end -}}

{{ if .Env.TOKEN_AUTH_URL -}}
// Authenticate using external service
config.tokenAuthUrl = '{{ .Env.TOKEN_AUTH_URL }}';
{{ end -}}


// Deployment information.
//

config.deploymentInfo = {};

{{ if .Env.DEPLOYMENTINFO_ENVIRONMENT -}}
config.deploymentInfo.environment = '{{ .Env.DEPLOYMENTINFO_ENVIRONMENT }}';
{{ end -}}

{{ if .Env.DEPLOYMENTINFO_SHARD -}}
config.deploymentInfo.shard = '{{ .Env.DEPLOYMENTINFO_SHARD }}';
{{ end -}}

{{ if .Env.DEPLOYMENTINFO_ENVIRONMENT_TYPE -}}
config.deploymentInfo.envType = '{{ .Env.DEPLOYMENTINFO_ENVIRONMENT_TYPE }}';
{{ end -}}

{{ if .Env.DEPLOYMENTINFO_REGION -}}
config.deploymentInfo.region = '{{ .Env.DEPLOYMENTINFO_REGION }}';
{{ end -}}

{{ if $DEPLOYMENTINFO_USERREGION -}}
config.deploymentInfo.userRegion = '{{ $DEPLOYMENTINFO_USERREGION }}';
{{ end -}}

// Deep Linking
config.disableDeepLinking = {{ $DISABLE_DEEP_LINKING }};

// P2P preferred codec
{{ if .Env.P2P_PREFERRED_CODEC -}}
config.p2p.preferredCodec = '{{ .Env.P2P_PREFERRED_CODEC }}';
{{ end -}}

// Video quality settings.
//

config.videoQuality = {};
{{ if .Env.VIDEOQUALITY_PREFERRED_CODEC -}}
config.videoQuality.preferredCodec = '{{ .Env.VIDEOQUALITY_PREFERRED_CODEC }}';
{{ end -}}

config.videoQuality.av1 = {};

{{ if .Env.VIDEOQUALITY_BITRATE_AV1_LOW }}
config.videoQuality.av1.low = {{ .Env.VIDEOQUALITY_BITRATE_AV1_LOW }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_AV1_STANDARD }}
config.videoQuality.av1.standard = {{ .Env.VIDEOQUALITY_BITRATE_AV1_STANDARD }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_AV1_HIGH }}
config.videoQuality.av1.high = {{ .Env.VIDEOQUALITY_BITRATE_AV1_HIGH }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_AV1_FULL }}
config.videoQuality.av1.fullHd = {{ .Env.VIDEOQUALITY_BITRATE_AV1_FULL }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_AV1_ULTRA }}
config.videoQuality.av1.ultraHd = {{ .Env.VIDEOQUALITY_BITRATE_AV1_ULTRA }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_AV1_SS_HIGH }}
config.videoQuality.av1.ssHigh = {{ .Env.VIDEOQUALITY_BITRATE_AV1_SS_HIGH }};
{{ end -}}

config.videoQuality.h264 = {};

{{ if .Env.VIDEOQUALITY_BITRATE_H264_LOW }}
config.videoQuality.h264.low = {{ .Env.VIDEOQUALITY_BITRATE_H264_LOW }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_H264_STANDARD }}
config.videoQuality.h264.standard = {{ .Env.VIDEOQUALITY_BITRATE_H264_STANDARD }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_H264_HIGH }}
config.videoQuality.h264.high = {{ .Env.VIDEOQUALITY_BITRATE_H264_HIGH }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_H264_FULL }}
config.videoQuality.h264.fullHd = {{ .Env.VIDEOQUALITY_BITRATE_H264_FULL }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_H264_ULTRA }}
config.videoQuality.h264.ultraHd = {{ .Env.VIDEOQUALITY_BITRATE_H264_ULTRA }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_H264_SS_HIGH }}
config.videoQuality.h264.ssHigh = {{ .Env.VIDEOQUALITY_BITRATE_H264_SS_HIGH }};
{{ end -}}

config.videoQuality.vp8 = {};

{{ if .Env.VIDEOQUALITY_BITRATE_VP8_LOW }}
config.videoQuality.vp8.low = {{ .Env.VIDEOQUALITY_BITRATE_VP8_LOW }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP8_STANDARD }}
config.videoQuality.vp8.standard = {{ .Env.VIDEOQUALITY_BITRATE_VP8_STANDARD }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP8_HIGH }}
config.videoQuality.vp8.high = {{ .Env.VIDEOQUALITY_BITRATE_VP8_HIGH }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP8_FULL }}
config.videoQuality.vp8.fullHd = {{ .Env.VIDEOQUALITY_BITRATE_VP8_FULL }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP8_ULTRA }}
config.videoQuality.vp8.ultraHd = {{ .Env.VIDEOQUALITY_BITRATE_VP8_ULTRA }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP8_SS_HIGH }}
config.videoQuality.vp8.ssHigh = {{ .Env.VIDEOQUALITY_BITRATE_VP8_SS_HIGH }};
{{ end -}}

config.videoQuality.vp9 = {};

{{ if .Env.VIDEOQUALITY_BITRATE_VP9_LOW }}
config.videoQuality.vp9.low = {{ .Env.VIDEOQUALITY_BITRATE_VP9_LOW }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP9_STANDARD }}
config.videoQuality.vp9.standard = {{ .Env.VIDEOQUALITY_BITRATE_VP9_STANDARD }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP9_HIGH }}
config.videoQuality.vp9.high = {{ .Env.VIDEOQUALITY_BITRATE_VP9_HIGH }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP9_FULL }}
config.videoQuality.vp9.fullHd = {{ .Env.VIDEOQUALITY_BITRATE_VP9_FULL }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP9_ULTRA }}
config.videoQuality.vp9.ultraHd = {{ .Env.VIDEOQUALITY_BITRATE_VP9_ULTRA }};
{{ end -}}

{{ if .Env.VIDEOQUALITY_BITRATE_VP9_SS_HIGH }}
config.videoQuality.vp9.ssHigh = {{ .Env.VIDEOQUALITY_BITRATE_VP9_SS_HIGH }};
{{ end -}}

 // Reactions
config.disableReactions = {{ $DISABLE_REACTIONS }};

// Polls
config.disablePolls = {{ $DISABLE_POLLS }};

// Configure toolbar buttons
{{ if .Env.TOOLBAR_BUTTONS -}}
config.toolbarButtons = [ '{{ join "','" (splitList "," .Env.TOOLBAR_BUTTONS) }}' ];
{{ end -}}

// Hides the buttons at pre-join screen
{{ if .Env.HIDE_PREMEETING_BUTTONS -}}
config.hiddenPremeetingButtons = [ '{{ join "','" (splitList "," .Env.HIDE_PREMEETING_BUTTONS) }}' ];
{{ end -}}

// Configure remote participant video menu
config.remoteVideoMenu = {
    disabled: {{ $DISABLE_REMOTE_VIDEO_MENU }},
    disableKick: {{ $DISABLE_KICKOUT }},
    disableGrantModerator: {{ $DISABLE_GRANT_MODERATOR }},
    disablePrivateChat: {{ $DISABLE_PRIVATE_CHAT }}
};

// Configure e2eping
config.e2eping = {
    enabled: {{ $ENABLE_E2EPING }}
};

{{ if .Env.E2EPING_NUM_REQUESTS -}}
config.e2eping.numRequests = {{ .Env.E2EPING_NUM_REQUESTS }};
{{ end -}}
{{ if .Env.E2EPING_MAX_CONFERENCE_SIZE -}}
config.e2eping.maxConferenceSize = {{ .Env.E2EPING_MAX_CONFERENCE_SIZE }};
{{ end -}}
{{ if .Env.E2EPING_MAX_MESSAGE_PER_SECOND -}}
config.e2eping.maxMessagePerSecond = {{ .Env.E2EPING_MAX_MESSAGE_PER_SECOND }};
{{ end }}

// Settings for the Excalidraw whiteboard integration.
config.whiteboard = {
    enabled: {{ $WHITEBOARD_ENABLED }},
    collabServerBaseUrl: '{{ $WHITEBOARD_COLLAB_SERVER_PUBLIC_URL }}'
};

// Testing
config.testing = {
    enableAv1Support: {{ $TESTING_AV1_SUPPORT }}
};
