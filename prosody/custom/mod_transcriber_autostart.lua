local LOGLEVEL = "info"

local is_admin = require "core.usermanager".is_admin
local is_healthcheck_room = module:require "util".is_healthcheck_room
local timer = require "util.timer"
local st = require "util.stanza"
local uuid = require "util.uuid".generate
module:log(LOGLEVEL, "loaded")

-- -----------------------------------------------------------------------------
local function _is_admin(jid)
    return is_admin(jid, module.host)
end

-- -----------------------------------------------------------------------------
local function _start_recording(room, session, stanza)
    -- Customize Jigasi JID to the one set up in your environment
    local jigasi_jid = "transcriber@recorder.meet.jitsi"; -- replace with Jigasi's actual JID

    -- Invite Jigasi to the room to start transcription
    module:log("info", "Inviting Jigasi for transcription to room: %s", room.jid);
    local jigasi_presence = st.presence({ from = jigasi_jid, to = room.jid })
        :tag("x", { xmlns = "http://jabber.org/protocol/muc" })

    room:route_stanza(jigasi_presence)  -- Use route_stanza instead of send

    -- Optionally, send a message indicating transcription has started
    local message = st.message({ type="groupchat", from = jigasi_jid, to = room.jid })
        :tag("body"):text("Transcription service has been activated for this room.")
    room:route_stanza(message)
    return
end

-- -----------------------------------------------------------------------------
module:hook("muc-room-created", function (event)
    local room = event.room
    local stanza = event.stanza
    local session = event.origin

    -- wait for the affiliation to set then start recording if applicable
    timer.add_task(3, function()
        _start_recording(room, session, stanza)
    end)
end)