config.toolbarButtons = [
  "microphone",
  "camera",
  // "closedcaptions",
  "desktop",
  "fullscreen",
  "fodeviceselection",
  "hangup",
  // "profile",
  "chat",
  // "settings",
  // "raisehand",
  // "videoquality",
  "filmstrip",
  // "invite",
  "feedback",
  // "shortcuts",
  // "tileview",
  "select-background",
  "participants-pane",
  "download",
  "help",
  "mute-everyone",
  "mute-video-everyone",
  "security",
];

config.disableDeepLinking = true;
// config.transcription.enabled = true;
// config.transcription.disableStartForAll = false;
// // config.transcription.useAppLanguage = false;
// // config.transcription.preferredLanguage = 'en-US';
// config.transcription.autoCaptionOnTranscribe = true;



config.breakoutRooms = {
    // Hides the add breakout room button. This replaces `hideAddRoomButton`.
    hideAddRoomButton: true,
    // Hides the auto assign participants button.
    hideAutoAssignButton: true,
    // Hides the join breakout room button.
    hideJoinRoomButton: true,
}

config.hideLoginButton = true;
config.securityUi = {
  ...(config.securityUi || {}),
  disableLobbyPassword: true,
};