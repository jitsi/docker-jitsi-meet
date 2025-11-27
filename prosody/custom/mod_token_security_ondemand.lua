--- Plugin to dynamically enable security features when required by token.
---
--- This module should be added to the main muc component.
---

local LOGLEVEL = "debug";

local util = module:require 'util';
local is_healthcheck_room = util.is_healthcheck_room;


module:hook("muc-occupant-joined", function (event)
    local room = event.room;

    if is_healthcheck_room(room.jid) then
        return;
    end

    if not event.origin.auth_token then
        module:log(LOGLEVEL,
            "skip security on demand, no token");
        return;
    end

    local context_room = event.origin.jitsi_meet_context_room;
    if not context_room then
        return;
    end

    local lobby_enabled = (room._data.lobbyroom ~= nil);

    -- create lobby if requested
    if context_room["lobby"] == true and not lobby_enabled then
        prosody.events.fire_event("create-persistent-lobby-room", {
            room = room,
            skip_display_name_check = true,
        });
    end

    -- destroy lobby if requested
    if context_room["lobby"] == false and lobby_enabled then
        room:set_members_only(false);
        prosody.events.fire_event('destroy-lobby-room', {
            room = room,
            newjid = room.jid,
        });
    end

    -- update password if set
    if type(context_room["password"]) == "string" then
        room:set_password(context_room["password"]);
    end
end);


module:hook("muc-occupant-pre-join", function (event)
    local room, occupant, stanza = event.room, event.occupant, event.stanza;
    local MUC_NS = "http://jabber.org/protocol/muc";

    if is_healthcheck_room(room.jid) then
        return;
    end

    if not event.origin.auth_token then
        module:log(LOGLEVEL, "skip the security bypass, no token");
        return;
    end

    local context_user = event.origin.jitsi_meet_context_user;
    if not context_user then
        return;
    end

    -- bypass security if allowed
    if context_user["security_bypass"] == true then
        module:log(LOGLEVEL, "Bypassing security for room %s occupant %s",
            room.jid, occupant.bare_jid);

        -- bypass password if exists
        local room_password = room:get_password();
        if room_password then
            local join = stanza:get_child("x", MUC_NS);

            if not join then
                join = stanza:tag("x", { xmlns = MUC_NS });
            end

            join:tag("password", { xmlns = MUC_NS }):text(room_password);
        end

        -- bypass lobby if exists
        local affiliation = room:get_affiliation(occupant.bare_jid);
        if not affiliation or affiliation == 0 then
            occupant.role = 'participant';
            room:set_affiliation(true, occupant.bare_jid, 'member');
        end
    end
end, -2);
--- Run just before lobby_bypass (priority -3), lobby(-4) and members_only (-5).
--- Must run after token_verification (99), max_occupants (10), allowners (2).