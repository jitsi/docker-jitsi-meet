-- File: /prosody-plugins/mod_auto_subtitles.lua

local st = require "util.stanza"

module:hook("muc-room-created", function(event)
    module:log("info", "Auto subtitles module triggered for new room.")
    local room = event.room

    -- Function to start transcription
    local start_transcription = function()
        module:log("info", "Starting transcription for room: %s", room.jid)

        -- Create a message stanza to start transcription
        local message = st.message({ type = "groupchat", from = room.jid })
            :tag("body"):text("!starttranscription"):up()
            :tag("nick", { xmlns = "http://jabber.org/protocol/nick" }):text("jigasi")

        -- Send the message to the room
        room:route_stanza(message)
    end

    -- Schedule the transcription start
    module:add_timer(1, start_transcription)
end)
