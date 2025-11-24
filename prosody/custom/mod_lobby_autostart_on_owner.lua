-- This module auto-activates lobby for all rooms.
--
-- This module should be added to the main muc component.
--

local jid_split = require 'util.jid'.split;

module:hook("muc-set-affiliation", function(event)
    local room = event.room;
    local jid = event.jid;
    local affiliation = event.affiliation;

    if not room then
        module:log("warn", "No room in muc-set-affiliation event");
        return;
    end

    local username = jid_split(jid);

    if username == "focus" or affiliation ~= "owner" then
        return;
    end

    if room._data.lobbyroom then
        module:log("debug", "Lobby already exists for %s", room.jid);
        return;
    end

    module:log("info", "Creating lobby for %s because %s became owner", room.jid, jid);
    prosody.events.fire_event('create-lobby-room', { room = room });
end);

module:hook("muc-occupant-left", function(event)
    local room = event.room;
    local occupant = event.occupant;

    if not room or not occupant then
        module:log("warn", "No room or occupant in muc-occupant-left event");
        return;
    end

    local occupant_jid = occupant.bare_jid;
    local aff = room:get_affiliation(occupant_jid);

    module:log("debug", "Occupant %s left, affiliation was %s", occupant_jid, tostring(aff));

    if aff ~= "owner" then
        module:log("debug", "Left occupant was not owner, ignoring");
        return;
    end

    local has_owner = false;
    for jid, affiliation in room:each_affiliation() do
        if affiliation == "owner" then
            local real_occupant = room:get_occupant_by_real_jid(jid);
            if real_occupant then
                module:log("debug", "Still alive owner found: %s", jid);
                has_owner = true;
                break;
            else
                module:log("debug", "Dead owner affiliation found: %s (not in room)", jid);
            end
        end
    end

    if has_owner then
        module:log("debug", "Room %s still has live owners, nothing to do", room.jid);
        return;
    end
end);
