// Cấu hình giao diện tùy chỉnh cho Jitsi Meet
// File này sẽ được sử dụng để tùy chỉnh giao diện người dùng

var interfaceConfig = {
    // Cấu hình cơ bản
    APP_NAME: 'Thanh Nguyen Meet',
    AUDIO_LEVEL_PRIMARY_COLOR: '#1976d2',
    AUDIO_LEVEL_SECONDARY_COLOR: '#ffffff',
    
    // Cấu hình logo và branding
    DEFAULT_LOGO_URL: 'https://meet.thanhnguyen.group/images/logo.png',
    DEFAULT_LOCAL_DISPLAY_NAME: 'Bạn',
    DEFAULT_LOGO_URL_HREF: 'https://thanhnguyen.group',
    DEFAULT_WELCOME_PAGE_LOGO_URL: 'https://meet.thanhnguyen.group/images/logo.png',
    
    // Cấu hình giao diện
    DISABLE_DOMINANT_SPEAKER_INDICATOR: false,
    DISABLE_FOCUS_INDICATOR: false,
    DISABLE_JOIN_LEAVE_NOTIFICATIONS: false,
    DISABLE_PRESENCE_STATUS: false,
    DISABLE_RINGING: false,
    DISABLE_TRANSCRIPTION_SUBTITLES: false,
    DISABLE_VIDEO_BACKGROUND: false,
    
    // Cấu hình toolbar
    INITIAL_TOOLBAR_TIMEOUT: 20000,
    JITSI_WATERMARK_LINK: 'https://thanhnguyen.group',
    
    // Cấu hình ngôn ngữ
    LANG_DETECTION: true,
    SUPPORTED_LANGUAGES: ['vi', 'en'],
    
    // Cấu hình giao diện nâng cao
    TOOLBAR_ALWAYS_VISIBLE: false,
    TOOLBAR_BUTTONS: [
        'microphone', 'camera', 'closedcaptions', 'desktop', 'embedmeeting',
        'fullscreen', 'fodeviceselection', 'hangup', 'profile', 'chat', 'recording',
        'livestreaming', 'etherpad', 'sharedvideo', 'settings', 'raisehand',
        'videoquality', 'filmstrip', 'feedback', 'stats', 'shortcuts',
        'tileview', 'videobackgroundblur', 'download', 'help', 'mute-everyone', 'security'
    ],
    
    // Cấu hình video
    VIDEO_LAYOUT_FIT: 'both',
    VIDEO_QUALITY_LABEL_DISABLED: false,
    
    // Cấu hình cửa sổ
    WELCOME_PAGE_ADDITIONAL_CARD_URL: '',
    WELCOME_PAGE_DISPLAY_JOIN_IN_PROGRESS: true,
    WELCOME_PAGE_LOGO_URL: 'https://meet.thanhnguyen.group/images/logo.png',
    WELCOME_PAGE_PARTICIPANT_TOOLBAR_BUTTONS: [],
    WELCOME_PAGE_SHOW_LOGO: true,
    WELCOME_PAGE_TITLE: 'Chào mừng đến với Thanh Nguyen Meet',
    
    // Cấu hình hình nền welcome page
    WELCOME_PAGE_BACKGROUND_URL: 'https://meet.thanhnguyen.group/images/welcome-background.jpg',
    WELCOME_PAGE_BACKGROUND_OPACITY: 0.3,
    
    // Cấu hình bảo mật
    ENABLE_WELCOME_PAGE: true,
    ENABLE_CLOSE_PAGE: false,
    ENABLE_DIALOUT: false,
    ENABLE_FEEDBACK_ANIMATION: false,
    ENABLE_FILMSTRIP_AUTOHIDE: true,
    ENABLE_FILMSTRIP_MAX_HEIGHT: 120,
    ENABLE_FOCUS_INDICATOR: true,
    ENABLE_GUESTS: true,
    ENABLE_JAAS_COMPONENTS: false,
    ENABLE_LAYOUTS: true,
    ENABLE_LIVE_STREAMING: false,
    ENABLE_MEETING_PASSWORD: false,
    ENABLE_NOTIFICATIONS: true,
    ENABLE_POLITE_MODE: false,
    ENABLE_PREJOIN_PAGE: true,
    ENABLE_RECORDING: false,
    ENABLE_REMOTE_VIDEO_MENU: true,
    ENABLE_SIMULCAST: true,
    ENABLE_STATS_ID: false,
    ENABLE_SUBDOMAINS: true,
    ENABLE_TALK_WHILE_MUTED: false,
    ENABLE_TILE_VIEW: true,
    ENABLE_TRANSCRIPTIONS: false,
    ENABLE_WELCOME_PAGE_ADDITIONAL_CARD: false,
    ENABLE_WELCOME_PAGE_LOGO: true,
    ENABLE_WELCOME_PAGE_PARTICIPANT_TOOLBAR_BUTTONS: false,
    ENABLE_WELCOME_PAGE_TITLE: true,
    
    // Cấu hình giao diện tùy chỉnh
    GENERATE_ROOMNAMES_ON_WELCOME_PAGE: true,
    HIDE_DEEP_LINKING_LOGO: false,
    HIDE_INVITE_MORE_HEADER: false,
    HIDE_PREMEETING_BUTTONS: [],
    HIDE_PREMEETING_EXTRA_BUTTONS: [],
    HIDE_WATERMARK: false,
    HIDE_WHITEBOARD_BUTTON: false,
    
    // Cấu hình ngôn ngữ và văn bản
    LANG_DETECTION: true,
    LIVE_STREAMING_HELP_LINK: 'https://jitsi.org/live',
    LOCAL_THUMBNAIL_RATIO: 16 / 9,
    MAXIMUM_ZOOMING_COEFFICIENT: 1.3,
    MOBILE_APP_PROMO: true,
    NATIVE_APP_NAME: 'Thanh Nguyen Meet',
    OPTIMISTIC_UI: true,
    POLICY_LOGO: null,
    PROVIDER_NAME: 'Thanh Nguyen Group',
    RECENT_LIST_ENABLED: true,
    REMOTE_VIDEO_MENU_DISABLED: false,
    RENAME_BUTTON_ENABLED: true,
    SETTINGS_SECTIONS: ['devices', 'language', 'moderator', 'profile', 'calendar', 'sounds', 'more'],
    SHOW_BRAND_WATERMARK: false,
    SHOW_BRAND_WATERMARK_FOR_GUESTS: false,
    SHOW_CHROME_EXTENSION_BANNER: false,
    SHOW_DEEP_LINKING_IMAGE: false,
    SHOW_JITSI_WATERMARK: false,
    SHOW_POLICY_WATERMARK: false,
    SHOW_POWERED_BY: false,
    SHOW_WATERMARK_FOR_GUESTS: true,
    START_AUDIO_MUTED: 10,
    START_AUDIO_ONLY: false,
    START_SILENT: false,
    START_VIDEO_MUTED: 10,
    START_WITH_AUDIO_MUTED: false,
    START_WITH_VIDEO_MUTED: false,
    SUPPORTED_LANGUAGES: ['vi', 'en'],
    TILE_VIEW_MAX_COLUMNS: 5,
    TOOLBAR_TIMEOUT: 4000,
    UNSUPPORTED_BROWSERS: [],
    VERTICAL_FILMSTRIP: true,
    VIDEO_QUALITY_LABEL_DISABLED: false,
    WHITEBOARD_ENABLED: false
};
