module:hook("muc-room-created", function(event)
    local room = event.room
    local start_transcription = function()
        -- Send a custom message to start transcription
        room:send_message({
            name = "transcription",
            type = "command",
            value = "start",
            sender = "jigasi@your.jitsi.domain"
        })
    end
    -- Schedule the transcription start
    module:add_timer(1, start_transcription)
end)