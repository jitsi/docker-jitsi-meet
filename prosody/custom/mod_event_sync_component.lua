--- Component to trigger an HTTP POST call on room/occupant events
--
--  Example config:
--
--    Component "esync.meet.mydomain.com" "event_sync_component"
--        muc_component = "conference.meet.mydomain.com"
--        breakout_component = "breakout.meet.mydomain.com"
--
--        api_prefix = "http://external_app.mydomain.com/api"
--
--        --- The following are all optional
--        include_speaker_stats = true  -- if true, total_dominant_speaker_time included in occupant payload
--        api_headers = {
--            ["Authorization"] = "Bearer TOKEN-237958623045";
--        }
--        api_timeout = 10  -- timeout if API does not respond within 10s
--        retry_count = 5  -- retry up to 5 times
--        api_retry_delay = 1  -- wait 1s between retries
--        api_should_retry_for_code = function (code)
--            return code >= 500 or code == 408
--        end
--

local json = require "util.json";
local jid = require 'util.jid';
local http = require "net.http";
local timer = require 'util.timer';
local util = module:require 'util';
local is_healthcheck_room = util.is_healthcheck_room;

local main_muc_component_host = module:get_option_string("muc_component");
local muc_domain_base = module:get_option_string("muc_mapper_domain_base");
local breakout_muc_component_host = module:get_option_string("breakout_component", "breakout." .. muc_domain_base);

local api_prefix = module:get_option("api_prefix");
local api_timeout = module:get_option("api_timeout", 20);
local api_headers = module:get_option("api_headers");
local api_retry_count = tonumber(module:get_option("api_retry_count", 3));
local api_retry_delay = tonumber(module:get_option("api_retry_delay", 1));

local include_speaker_stats = module:get_option("include_speaker_stats", false);


-- Option for user to control HTTP response codes that will result in a retry.
-- Defaults to returning true on any 5XX code or 0
local api_should_retry_for_code = module:get_option("api_should_retry_for_code", function (code)
   return code >= 500;
end)

-- Cannot proceed if "api_prefix" not configured
if not api_prefix then
    module:log("error", "api_prefix not specified. Disabling %s", module:get_name());
    return;
end

if main_muc_component_host == nil then
    log("error", "No muc_component specified. No muc to operate on!");
    return;
end

-- common HTTP headers added to all API calls
local http_headers = {
    ["User-Agent"] = "Prosody ("..prosody.version.."; "..prosody.platform..")";
    ["Content-Type"] = "application/json";
};
if api_headers then -- extra headers from config
    for key, value in pairs(api_headers) do
       http_headers[key] = value;
    end
end

local URL_EVENT_ROOM_CREATED = api_prefix..'/events/room/created';
local URL_EVENT_ROOM_DESTROYED = api_prefix..'/events/room/destroyed';
local URL_EVENT_OCCUPANT_JOINED = api_prefix..'/events/occupant/joined';
local URL_EVENT_OCCUPANT_LEFT = api_prefix..'/events/occupant/left';


--- Start non-blocking HTTP call
-- @param url URL to call
-- @param options options table as expected by net.http where we provide optional headers, body or method.
-- @param callback if provided, called with callback(response_body, response_code) when call complete.
-- @param timeout_callback if provided, called without args when request times out.
-- @param retries how many times to retry on failure; 0 means no retries.
local function async_http_request(url, options, callback, timeout_callback, retries)
    local completed = false;
    local timed_out = false;
    local _retries = retries or api_retry_count;

    local function cb_(response_body, response_code)
        if not timed_out then  -- request completed before timeout
            completed = true;
            if (response_code == 0 or api_should_retry_for_code(response_code)) and _retries > 0 then
                module:log("warn", "API Response code %d. Will retry after %ds", response_code, api_retry_delay);
                timer.add_task(api_retry_delay, function()
                    async_http_request(url, options, callback, timeout_callback, _retries - 1)
                end)
                return;
            end

            module:log("debug", "%s %s returned code %s", options.method, url, response_code);

            if callback then
                callback(response_body, response_code)
            end
        end
    end

    local request = http.request(url, options, cb_);

    timer.add_task(api_timeout, function ()
        timed_out = true;

        if not completed then
            http.destroy_request(request);
            if timeout_callback then
                timeout_callback()
            end
        end
    end);

end

--- Returns current timestamp
local function now()
    return os.time();
end


--- Start EventData implementation
local EventData = {};
EventData.__index = EventData;

function new_EventData(room_jid)
    return setmetatable({
        room_jid = room_jid;
        room_name = jid.node(room_jid);
        created_at = now();
        occupants = {};  -- table of all (past and present) occupants data
        active = {};  -- set of active occupants (by occupant jid)
    }, EventData);
end

--- Handle new occupant joining room
function EventData:on_occupant_joined(occupant_jid, event_origin)
    local user_context = event_origin.jitsi_meet_context_user or {};

    -- N.B. we only store user details on join and assume they don't change throughout the duration of the meeting
    local occupant_data = {
        occupant_jid   = occupant_jid;
        name  = user_context.name;
        id  = user_context.id;
        email  = user_context.email;
        joined_at = now();
        left_at = nil;
    };

    self.occupants[occupant_jid] = occupant_data;
    self.active[occupant_jid] = true;

    return occupant_data;
end

--- Handle occupant leaving room
function EventData:on_occupant_leave(occupant_jid, room)
    local left_at = now();
    self.active[occupant_jid] = nil;

    local occupant_data = self.occupants[occupant_jid];
    if occupant_data then
        occupant_data['left_at'] = left_at;
    end

    if include_speaker_stats and room.speakerStats then
        occupant_data['total_dominant_speaker_time'] = room.speakerStats[occupant_jid].totalDominantSpeakerTime
    end

    return occupant_data;
end


--- Returns array of all (past or present) occupants
function EventData:get_occupant_array()
    local output = {};
    for _, occupant_data in pairs(self.occupants) do
        table.insert(output, occupant_data)
    end

    return output;
end

--- Returns number of active occupants
function EventData:get_active_occupants_count()
    local output = 0;
    for _ in pairs(self.active) do
        output = output + 1
    end

    return output;
end

--- End EventData implementation


--- Checks if event is triggered by healthchecks or focus user.
function is_system_event(event)
    if is_healthcheck_room(event.room.jid) then
        return true;
    end

    if event.occupant and jid.node(event.occupant.jid) == "focus" then
        return true;
    end

    return false;
end

--- Updates payload with additional attributes from room._data.event_sync_extra_payload
function update_with_room_attributes(payload, room)
    if room._data and room._data.event_sync_extra_payload then
        for k,v in pairs(room._data.event_sync_extra_payload) do
            payload[k] = v;
        end
    end
end


--- Callback when new room created
function room_created(event)
    if is_system_event(event) then
        return;
    end

    local room = event.room;

    module:log("info", "Start tracking occupants for %s", room.jid);
    local room_data = new_EventData(room.jid);
    room.event_data = room_data;

    local payload = {
        ['event_name'] = 'muc-room-created';
        ['created_at'] = room_data.created_at;
    };
    update_with_room_attributes(payload, room);

    async_http_request(URL_EVENT_ROOM_CREATED, {
        headers = http_headers;
        method = "POST";
        body = json.encode(payload);
    })
end

--- Callback when room destroyed
function room_destroyed(event)
    if is_system_event(event) then
        return;
    end

    local room = event.room;
    local room_data = room.event_data;
    local destroyed_at = now();

    module:log("info", "Room destroyed - %s", room.jid);

    if not room_data then
        module:log("error", "(room destroyed) Room has no Event data - %s", room.jid);
        return;
    end

    local payload = {
            ['event_name'] = 'muc-room-destroyed';
            ['created_at'] = room_data.created_at;
            ['destroyed_at'] = destroyed_at;
            ['all_occupants'] = room_data:get_occupant_array();
    };
    update_with_room_attributes(payload, room);

    async_http_request(URL_EVENT_ROOM_DESTROYED, {
        headers = http_headers;
        method = "POST";
        body = json.encode(payload);
    })
end

--- Callback when an occupant joins room
function occupant_joined(event)
    if is_system_event(event) then
        return;
    end

    local room = event.room;
    local room_data = room.event_data;
    local occupant_jid = event.occupant.jid;

    if not room_data then
        module:log("error", "(occupant joined) Room has no Event data - %s", room.jid);
        return;
    end

    local occupant_data = room_data:on_occupant_joined(occupant_jid, event.origin);
    module:log("info", "New occupant - %s", json.encode(occupant_data));

    local payload = {
            ['event_name'] = 'muc-occupant-joined';
            ['occupant'] = occupant_data;
            ['active_occupants_count'] = room_data:get_active_occupants_count();
    };
    update_with_room_attributes(payload, room);

    async_http_request(URL_EVENT_OCCUPANT_JOINED, {
        headers = http_headers;
        method = "POST";
        body = json.encode(payload);
    })
end

--- Callback when an occupant has left room
function occupant_left(event)
    local room = event.room;

    if is_system_event(event) then
        return;
    end

    local occupant_jid = event.occupant.jid;
    local room_data = room.event_data;

    if not room_data then
        module:log("error", "(occupant left) Room has no Event data - %s", room.jid);
        return;
    end

    local occupant_data = room_data:on_occupant_leave(occupant_jid, room);
    module:log("info", "Occupant left - %s", json.encode(occupant_data));

    local payload = {
            ['event_name'] = 'muc-occupant-left';
            ['occupant'] = occupant_data;
            ['active_occupants_count'] = room_data:get_active_occupants_count();
    };
    update_with_room_attributes(payload, room);

    async_http_request(URL_EVENT_OCCUPANT_LEFT, {
        headers = http_headers;
        method = "POST";
        body = json.encode(payload);
    })
end


-- Helper function to wait till a component is loaded before running the given callback
function run_when_component_loaded(component_host_name, callback)
    local function trigger_callback()
        module:log('info', 'Component loaded %s', component_host_name);
        callback(module:context(component_host_name), component_host_name);
    end

    if prosody.hosts[component_host_name] == nil then
        module:log('debug', 'Host %s not yet loaded. Will trigger when it is loaded.', component_host_name);
        prosody.events.add_handler('host-activated', function (host)
            if host == component_host_name then
                trigger_callback();
            end
        end);
    else
        trigger_callback();
    end
end

-- Helper function to wait till a component's muc module is loaded before running the given callback
function run_when_muc_module_loaded(component_host_module, component_host_name, callback)
    local function trigger_callback()
        module:log('info', 'MUC module loaded for %s', component_host_name);
        callback(prosody.hosts[component_host_name].modules.muc, component_host_module);
    end

    if prosody.hosts[component_host_name].modules.muc == nil then
        module:log('debug', 'MUC module for %s not yet loaded. Will trigger when it is loaded.', component_host_name);
        prosody.hosts[component_host_name].events.add_handler('module-loaded', function(event)
            if (event.module == 'muc') then
                trigger_callback();
            end
        end);
    else
        trigger_callback()
    end
end

local main_muc_service; -- luacheck: ignore

-- No easy way to infer main room from breakout room object, so search all rooms in main muc component and cache
-- it on room so we don't have to search again
-- Speakerstats component does exactly the same thing, so if that is loaded, we get this for free.
local function get_main_room(breakout_room)
    if breakout_room._data and breakout_room._data.main_room then
        return breakout_room._data.main_room;
    end

    -- let's search all rooms to find the main room
    for room in main_muc_service.each_room() do
        if room._data and room._data.breakout_rooms_active and room._data.breakout_rooms[breakout_room.jid] then
            breakout_room._data.main_room = room;
            return room;
        end
    end
end


-- Predefine room attributes to be included in API payload for all events
function handle_main_room_created(event)
    local room = event.room;
    if is_healthcheck_room(room.jid) then
        return;
    end

    room._data.event_sync_extra_payload = {
        ['is_breakout'] = false;
        ['room_jid'] = room.jid;
        ['room_name'] = jid.split(room.jid);
    }
    room:save();
end


-- Predefine breakout room attributes to be included in API payload for all events
-- This should be scheduled AFTER speakerStats module, but BEFORE handler that compiles and sends API payload
function handle_breakout_room_created(event)
    local room = event.room;
    if is_healthcheck_room(room.jid) then
        return;
    end

    local main_room = get_main_room(room);
    room._data.event_sync_extra_payload = {
        ['is_breakout'] = true;
        ['breakout_room_id'] = jid.split(room.jid);
        -- use name/jid of parent room as the room_* info
        ['room_jid'] = main_room.jid;
        ['room_name'] = jid.split(main_room.jid);
    }
    room:save();
end

-- Handle events on main muc module
run_when_component_loaded(main_muc_component_host, function(host_module, host_name)
    run_when_muc_module_loaded(host_module, host_name, function (main_muc, main_module)
        main_muc_service = main_muc;  -- so it can be accessed from breakout muc event handlers

        -- the following must run after speakerstats (priority -1)
        main_module:hook("muc-room-created", handle_main_room_created, -2);
        main_module:hook("muc-room-created", room_created, -3);  -- must run after handle_main_room_created
        main_module:hook("muc-occupant-joined", occupant_joined, -2);
        main_module:hook("muc-occupant-left", occupant_left, -2);
        main_module:hook("muc-room-destroyed", room_destroyed, -2);
    end);
end);

-- Handle events on breakout muc module
run_when_component_loaded(breakout_muc_component_host, function(host_module, host_name)
    run_when_muc_module_loaded(host_module, host_name, function (_, breakout_module)

        -- the following must run after speakerstats (priority -1)
        breakout_module:hook("muc-room-created", handle_breakout_room_created, -2);
        breakout_module:hook("muc-room-created", room_created, -3); -- must run after handle_breakout_room_created
        breakout_module:hook("muc-occupant-joined", occupant_joined, -2);
        breakout_module:hook("muc-occupant-left", occupant_left, -2);
        breakout_module:hook("muc-room-destroyed", room_destroyed, -2);
    end);
end);