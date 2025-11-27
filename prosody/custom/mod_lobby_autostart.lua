-- This module auto-activates lobby for all rooms.
--
-- IMPORTANT: do not use this unless you have some mechanism for moderators to bypass the lobby, otherwise everybody
--            stops at the lobby with nobody to admit them.
--
-- This module should be added to the main muc component.
--

local util = module:require "util";
local is_healthcheck_room = util.is_healthcheck_room;


module:hook("muc-room-pre-create", function (event)
   local room = event.room;

    if is_healthcheck_room(room.jid) then
        return;
    end

    prosody.events.fire_event("create-persistent-lobby-room", { room = room; });
end);

