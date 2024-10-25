local st = require "util.stanza"

module:hook("muc-room-created", function(event)
    module:log("info", "Auto subtitles module triggered for new room.")
    local room = event.room

    -- Ensure room object exists
    if not room then
        module:log("error", "Room object is nil.")
        return
    end

    -- Function to start subtitles
    local start_subtitles = function()
        module:log("info", "Attempting to start subtitles for room: %s", room.jid)

        -- Create a message stanza to start subtitles
        local message = st.message({ type = "groupchat", from = room.jid })
            :tag("body"):text("!startsubtitles"):up()
            :tag("nick", { xmlns = "http://jabber.org/protocol/nick" }):text("jigasi")

        -- Send the message to the room
        local success, err = pcall(function() room:route_stanza(message) end)
        if not success then
            module:log("error", "Failed to send subtitles start message: %s", err)
        else
            module:log("info", "Subtitles start message sent successfully.")
        end
    end

    -- Schedule the subtitles start
    module:add_timer(1, start_subtitles)
end)