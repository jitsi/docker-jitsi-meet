-- module: mod_auto_jigasi.lua
local jid_split = require "util.jid".split;
local st = require("util.stanza");

local muc_domain_base = module:get_option_string("muc_mapper_domain_base");
local jigasi_bare_jid = module:get_option_string("muc_jigasi_jid", "jigasi@auth." .. muc_domain_base);
local focus_jid = module:get_option_string("muc_jicofo_brewery_jid", "focus@" .. muc_domain_base);

local function invite_jigasi_to_room(room_jid)
    module:log("This starts for Brice")
end

module:hook("muc-room-created", function(event)
    local room = event.room;
    invite_jigasi_to_room(room.jid);
end);
