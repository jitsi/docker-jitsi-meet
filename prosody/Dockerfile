FROM jitsi/prosody:prosody-13.0.2

COPY custom/mod_event_sync_component.lua              /prosody-plugins-custom/mod_event_sync_component.lua
COPY custom/mod_owner_restricted.lua              /prosody-plugins-custom/mod_owner_restricted.lua
COPY custom/mod_token_security_ondemand.lua              /prosody-plugins-custom/mod_token_security_ondemand.lua
COPY custom/mod_token_owner_party.lua              /prosody-plugins-custom/mod_token_owner_party.lua
COPY custom/mod_lobby_autostart.lua              /prosody-plugins-custom/mod_lobby_autostart.lua

EXPOSE 5222 5280