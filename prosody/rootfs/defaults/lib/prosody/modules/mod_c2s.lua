-- Prosody IM
-- Copyright (C) 2008-2010 Matthew Wild
-- Copyright (C) 2008-2010 Waqas Hussain
--
-- This project is MIT/X11 licensed. Please see the
-- COPYING file in the source package for more information.
--

module:set_global();

local add_task = require "util.timer".add_task;
local new_xmpp_stream = require "util.xmppstream".new;
local nameprep = require "util.encodings".stringprep.nameprep;
local sessionmanager = require "core.sessionmanager";
local statsmanager = require "core.statsmanager";
local st = require "util.stanza";
local sm_new_session, sm_destroy_session = sessionmanager.new_session, sessionmanager.destroy_session;
local uuid_generate = require "util.uuid".generate;
local async = require "util.async";
local runner = async.runner;

local tostring, type = tostring, type;

local xmlns_xmpp_streams = "urn:ietf:params:xml:ns:xmpp-streams";

local log = module._log;

local c2s_timeout = module:get_option_number("c2s_timeout", 300);
local stream_close_timeout = module:get_option_number("c2s_close_timeout", 5);
local opt_keepalives = module:get_option_boolean("c2s_tcp_keepalives", module:get_option_boolean("tcp_keepalives", true));
local stanza_size_limit = module:get_option_number("c2s_stanza_size_limit", 1024*256);

local measure_connections = module:metric("gauge", "connections", "", "Established c2s connections", {"host", "type", "ip_family"});

local sessions = module:shared("sessions");
local core_process_stanza = prosody.core_process_stanza;
local hosts = prosody.hosts;

local stream_callbacks = { default_ns = "jabber:client" };
local listener = {};
local runner_callbacks = {};

local m_tls_params = module:metric(
	"counter", "encrypted", "",
	"Encrypted connections",
	{"protocol"; "cipher"}
);

module:hook("stats-update", function ()
	-- for push backends, avoid sending out updates for each increment of
	-- the metric below.
	statsmanager.cork()
	measure_connections:clear()
	for _, session in pairs(sessions) do
		local host = session.host or ""
		local type_ = session.type or "other"

		-- we want to expose both v4 and v6 counters in all cases to make
		-- queries smoother
		local is_ipv6 = session.ip and session.ip:match(":") and 1 or 0
		local is_ipv4 = 1 - is_ipv6
		measure_connections:with_labels(host, type_, "ipv4"):add(is_ipv4)
		measure_connections:with_labels(host, type_, "ipv6"):add(is_ipv6)
	end
	statsmanager.uncork()
end);

--- Stream events handlers
local stream_xmlns_attr = {xmlns='urn:ietf:params:xml:ns:xmpp-streams'};

function stream_callbacks.streamopened(session, attr)
	-- run _streamopened in async context
	session.thread:run({ stream = "opened", attr = attr });
end

function stream_callbacks._streamopened(session, attr)
	local send = session.send;
	if not attr.to then
		session:close{ condition = "improper-addressing",
			text = "A 'to' attribute is required on stream headers" };
		return;
	end
	local host = nameprep(attr.to);
	if not host then
		session:close{ condition = "improper-addressing",
			text = "A valid 'to' attribute is required on stream headers" };
		return;
	end
	if not session.host then
		session.host = host;
	elseif session.host ~= host then
		session:close{ condition = "not-authorized",
			text = "The 'to' attribute must remain the same across stream restarts" };
		return;
	end
	session.version = tonumber(attr.version) or 0;
	session.streamid = uuid_generate();
	(session.log or log)("debug", "Client sent opening <stream:stream> to %s", session.host);

	if not hosts[session.host] or not hosts[session.host].modules.c2s then
		-- We don't serve this host...
		session:close{ condition = "host-unknown", text = "This server does not serve "..tostring(session.host)};
		return;
	end

	session:open_stream(host, attr.from);

	-- Opening the stream can cause the stream to be closed
	if session.destroyed then return end

	(session.log or log)("debug", "Sent reply <stream:stream> to client");
	session.notopen = nil;

	-- If session.secure is *false* (not nil) then it means we /were/ encrypting
	-- since we now have a new stream header, session is secured
	if session.secure == false then
		session.secure = true;
		session.encrypted = true;

		local sock = session.conn:socket();
		local info = sock.info and sock:info();
		if type(info) == "table" then
			(session.log or log)("info", "Stream encrypted (%s with %s)", info.protocol, info.cipher);
			session.compressed = info.compression;
			m_tls_params:with_labels(info.protocol, info.cipher):add(1)
		else
			(session.log or log)("info", "Stream encrypted");
		end
	end

	local features = st.stanza("stream:features");
	hosts[session.host].events.fire_event("stream-features", { origin = session, features = features });
	if features.tags[1] or session.full_jid then
		send(features);
	else
		if session.secure then
			-- Here SASL should be offered
			(session.log or log)("warn", "No stream features to offer on secure session. Check authentication settings.");
		else
			-- Normally STARTTLS would be offered
			(session.log or log)("warn", "No stream features to offer on insecure session. Check encryption and security settings.");
		end
		session:close{ condition = "undefined-condition", text = "No stream features to proceed with" };
	end
end

function stream_callbacks.streamclosed(session, attr)
	-- run _streamclosed in async context
	session.thread:run({ stream = "closed", attr = attr });
end

function stream_callbacks._streamclosed(session)
	session.log("debug", "Received </stream:stream>");
	session:close(false);
end

function stream_callbacks.error(session, error, data)
	if error == "no-stream" then
		session.log("debug", "Invalid opening stream header (%s)", (data:gsub("^([^\1]+)\1", "{%1}")));
		session:close("invalid-namespace");
	elseif error == "parse-error" then
		(session.log or log)("debug", "Client XML parse error: %s", data);
		session:close("not-well-formed");
	elseif error == "stream-error" then
		local condition, text = "undefined-condition";
		for child in data:childtags(nil, xmlns_xmpp_streams) do
			if child.name ~= "text" then
				condition = child.name;
			else
				text = child:get_text();
			end
			if condition ~= "undefined-condition" and text then
				break;
			end
		end
		text = condition .. (text and (" ("..text..")") or "");
		session.log("info", "Session closed by remote with error: %s", text);
		session:close(nil, text);
	end
end

function stream_callbacks.handlestanza(session, stanza)
	stanza = session.filter("stanzas/in", stanza);
	session.thread:run(stanza);
end

--- Session methods
local function session_close(session, reason)
	local log = session.log or log;
	local close_event_payload = { session = session, reason = reason };
	module:context(session.host):fire_event("pre-session-close", close_event_payload);
	reason = close_event_payload.reason;
	if session.conn then
		if session.notopen then
			session:open_stream();
		end
		if reason then -- nil == no err, initiated by us, false == initiated by client
			local stream_error = st.stanza("stream:error");
			if type(reason) == "string" then -- assume stream error
				stream_error:tag(reason, {xmlns = 'urn:ietf:params:xml:ns:xmpp-streams' });
			elseif st.is_stanza(reason) then
				stream_error = reason;
			elseif type(reason) == "table" then
				if reason.condition then
					stream_error:tag(reason.condition, stream_xmlns_attr):up();
					if reason.text then
						stream_error:tag("text", stream_xmlns_attr):text(reason.text):up();
					end
					if reason.extra then
						stream_error:add_child(reason.extra);
					end
				end
			end
			stream_error = tostring(stream_error);
			log("debug", "Disconnecting client, <stream:error> is: %s", stream_error);
			session.send(stream_error);
		end

		session.send("</stream:stream>");
		function session.send() return false; end

		local reason_text = (reason and (reason.name or reason.text or reason.condition)) or reason;
		session.log("debug", "c2s stream for %s closed: %s", session.full_jid or session.ip or "<unknown>", reason_text or "session closed");

		-- Authenticated incoming stream may still be sending us stanzas, so wait for </stream:stream> from remote
		local conn = session.conn;
		if reason_text == nil and not session.notopen and session.type == "c2s" then
			-- Grace time to process data from authenticated cleanly-closed stream
			add_task(stream_close_timeout, function ()
				if not session.destroyed then
					session.log("warn", "Failed to receive a stream close response, closing connection anyway...");
					sm_destroy_session(session, reason_text);
					if conn then conn:close(); end
				end
			end);
		else
			sm_destroy_session(session, reason_text);
			if conn then conn:close(); end
		end
	else
		local reason_text = (reason and (reason.name or reason.text or reason.condition)) or reason;
		sm_destroy_session(session, reason_text);
	end
end

-- Close all user sessions with the specified reason. If leave_resource is
-- true, the resource named by event.resource will not be closed.
local function disconnect_user_sessions(reason, leave_resource)
	return function (event)
		local username, host, resource = event.username, event.host, event.resource;
		local user = hosts[host].sessions[username];
		if user and user.sessions then
			for r, session in pairs(user.sessions) do
				if not leave_resource or r ~= resource then
					session:close(reason);
				end
			end
		end
	end
end

module:hook_global("user-password-changed", disconnect_user_sessions({ condition = "reset", text = "Password changed" }, true), 200);
module:hook_global("user-roles-changed", disconnect_user_sessions({ condition = "reset", text = "Roles changed" }), 200);
module:hook_global("user-deleted", disconnect_user_sessions({ condition = "not-authorized", text = "Account deleted" }), 200);

function runner_callbacks:ready()
	if self.data.conn then
		self.data.conn:resume();
	else
		(self.data.log or log)("debug", "Session has no connection to resume");
	end
end

function runner_callbacks:waiting()
	if self.data.conn then
		self.data.conn:pause();
	else
		(self.data.log or log)("debug", "Session has no connection to pause while waiting");
	end
end

function runner_callbacks:error(err)
	(self.data.log or log)("error", "Traceback[c2s]: %s", err);
end

--- Port listener
function listener.onconnect(conn)
	local session = sm_new_session(conn);

	session.log("info", "Client connected");

	-- Client is using Direct TLS or legacy SSL (otherwise mod_tls sets this flag)
	if conn:ssl() then
		session.secure = true;
		session.encrypted = true;

		-- Check if TLS compression is used
		local sock = conn:socket();
		local info = sock.info and sock:info();
		if type(info) == "table" then
			(session.log or log)("info", "Stream encrypted (%s with %s)", info.protocol, info.cipher);
			session.compressed = info.compression;
			m_tls_params:with_labels(info.protocol, info.cipher):add(1)
		else
			(session.log or log)("info", "Stream encrypted");
		end
	end

	if opt_keepalives then
		conn:setoption("keepalive", opt_keepalives);
	end

	session.close = session_close;

	local stream = new_xmpp_stream(session, stream_callbacks, stanza_size_limit);
	session.stream = stream;
	session.notopen = true;

	function session.reset_stream()
		session.notopen = true;
		session.stream:reset();
	end

	session.thread = runner(function (stanza)
		if st.is_stanza(stanza) then
			core_process_stanza(session, stanza);
		elseif stanza.stream == "opened" then
			stream_callbacks._streamopened(session, stanza.attr);
		elseif stanza.stream == "closed" then
			stream_callbacks._streamclosed(session, stanza.attr);
		end
	end, runner_callbacks, session);

	local filter = session.filter;
	function session.data(data)
		-- Parse the data, which will store stanzas in session.pending_stanzas
		if data then
			data = filter("bytes/in", data);
			if data then
				local ok, err = stream:feed(data);
				if not ok then
					log("debug", "Received invalid XML (%s) %d bytes: %q", err, #data, data:sub(1, 300));
					if err == "stanza-too-large" then
						session:close({
							condition = "policy-violation",
							text = "XML stanza is too big",
							extra = st.stanza("stanza-too-big", { xmlns = 'urn:xmpp:errors' }),
						});
					else
						session:close("not-well-formed");
					end
				end
			end
		end
	end

	if c2s_timeout then
		add_task(c2s_timeout, function ()
			if session.type == "c2s_unauthed" then
				(session.log or log)("debug", "Connection still not authenticated after c2s_timeout=%gs, closing it", c2s_timeout);
				session:close("connection-timeout");
			end
		end);
	end

	session.dispatch_stanza = stream_callbacks.handlestanza;

	sessions[conn] = session;
end

function listener.onincoming(conn, data)
	local session = sessions[conn];
	if session then
		session.data(data);
	end
end

function listener.ondisconnect(conn, err)
	local session = sessions[conn];
	if session then
		(session.log or log)("info", "Client disconnected: %s", err or "connection closed");
		sm_destroy_session(session, err);
		session.conn = nil;
		sessions[conn]  = nil;
	end
	module:fire_event("c2s-closed", { session = session; conn = conn });
end

function listener.onreadtimeout(conn)
	local session = sessions[conn];
	if session then
		return (hosts[session.host] or prosody).events.fire_event("c2s-read-timeout", { session = session });
	end
end

function listener.ondrain(conn)
	local session = sessions[conn];
	if session then
		return (hosts[session.host] or prosody).events.fire_event("c2s-ondrain", { session = session });
	end
end

function listener.onpredrain(conn)
	local session = sessions[conn];
	if session then
		return (hosts[session.host] or prosody).events.fire_event("c2s-pre-ondrain", { session = session });
	end
end

local function keepalive(event)
	local session = event.session;
	if not session.notopen then
		return event.session.send(' ');
	end
end

function listener.associate_session(conn, session)
	sessions[conn] = session;
end

function module.add_host(module)
	module:hook("c2s-read-timeout", keepalive, -1);
end

module:hook("c2s-read-timeout", keepalive, -1);

module:hook("server-stopping", function(event) -- luacheck: ignore 212/event
	-- Close ports
	local pm = require "core.portmanager";
	for _, netservice in pairs(module.items["net-provider"]) do
		pm.unregister_service(netservice.name, netservice);
	end
end, -80);

module:hook("server-stopping", function(event)
	local wait, done = async.waiter(1, true);
	module:hook("c2s-closed", function ()
		if next(sessions) == nil then done(); end
	end)

	-- Close sessions
	local reason = event.reason;
	for _, session in pairs(sessions) do
		session:close{ condition = "system-shutdown", text = reason };
	end

	-- Wait for them to close properly if they haven't already
	if next(sessions) ~= nil then
		add_task(stream_close_timeout+1, function () done() end);
		module:log("info", "Waiting for sessions to close");
		wait();
	end

end, -100);



module:provides("net", {
	name = "c2s";
	listener = listener;
	default_port = 5222;
	encryption = "starttls";
	multiplex = {
		protocol = "xmpp-client";
		pattern = "^<.*:stream.*%sxmlns%s*=%s*(['\"])jabber:client%1.*>";
	};
});

module:provides("net", {
	name = "c2s_direct_tls";
	listener = listener;
	encryption = "ssl";
	multiplex = {
		pattern = "^<.*:stream.*%sxmlns%s*=%s*(['\"])jabber:client%1.*>";
	};
});

-- COMPAT
module:provides("net", {
	name = "legacy_ssl";
	listener = listener;
	encryption = "ssl";
	multiplex = {
		pattern = "^<.*:stream.*%sxmlns%s*=%s*(['\"])jabber:client%1.*>";
	};
});


