local st = require "util.stanza"

module:hook("muc-room-created", function(event)
    module:log("info", "Auto subtitles module triggered for new room.")
    local room = event.room

    -- Check if room exists and is ready
    if not room then
        module:log("error", "Room object is nil.")
        return
    end

    -- Function to start transcription
    local start_transcription = function()
        module:log("info", "Attempting to start transcription for room: %s", room.jid)

        -- Create a message stanza to start transcription
        local message = st.message({ type = "groupchat", from = room.jid })
            :tag("body"):text("!starttranscription"):up()
            :tag("nick", { xmlns = "http://jabber.org/protocol/nick" }):text("jigasi")

        -- Send the message to the room
        local success, err = pcall(function() room:route_stanza(message) end)
        if not success then
            module:log("error", "Failed to send transcription start message: %s", err)
        else
            module:log("info", "Transcription start message sent successfully.")
        end
    end

    -- Schedule the transcription start
    module:add_timer(1, start_transcription)
end)
