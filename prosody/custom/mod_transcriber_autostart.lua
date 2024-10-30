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
local function _start_recording(room, session)
    module:log("info", "Ok let us start")
    return
end

-- -----------------------------------------------------------------------------
module:hook("muc-room-created", function (event)
    local room = event.room
    local session = event.origin

    -- wait for the affiliation to set then start recording if applicable
    timer.add_task(3, function()
        _start_recording(room, session)
    end)
end)