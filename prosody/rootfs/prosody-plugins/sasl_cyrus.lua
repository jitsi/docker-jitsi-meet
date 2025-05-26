-- sasl.lua v0.4
-- Copyright (C) 2008-2009 Tobias Markmann
--
--    All rights reserved.
--
--    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
--
--        * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--        * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--        * Neither the name of Tobias Markmann nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
--
--    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

local cyrussasl = require "cyrussasl";
local log = require "util.logger".init("sasl_cyrus");

local setmetatable = setmetatable

local pcall = pcall
local s_match, s_gmatch = string.match, string.gmatch

local sasl_errstring = {
	-- SASL result codes --
	[1]   = "another step is needed in authentication";
	[0]   = "successful result";
	[-1]  = "generic failure";
	[-2]  = "memory shortage failure";
	[-3]  = "overflowed buffer";
	[-4]  = "mechanism not supported";
	[-5]  = "bad protocol / cancel";
	[-6]  = "can't request info until later in exchange";
	[-7]  = "invalid parameter supplied";
	[-8]  = "transient failure (e.g., weak key)";
	[-9]  = "integrity check failed";
	[-12] = "SASL library not initialized";

	-- client only codes --
	[2]   = "needs user interaction";
	[-10] = "server failed mutual authentication step";
	[-11] = "mechanism doesn't support requested feature";

	-- server only codes --
	[-13] = "authentication failure";
	[-14] = "authorization failure";
	[-15] = "mechanism too weak for this user";
	[-16] = "encryption needed to use mechanism";
	[-17] = "One time use of a plaintext password will enable requested mechanism for user";
	[-18] = "passphrase expired, has to be reset";
	[-19] = "account disabled";
	[-20] = "user not found";
	[-23] = "version mismatch with plug-in";
	[-24] = "remote authentication server unavailable";
	[-26] = "user exists, but no verifier for user";

	-- codes for password setting --
	[-21] = "passphrase locked";
	[-22] = "requested change was not needed";
	[-27] = "passphrase is too weak for security policy";
	[-28] = "user supplied passwords not permitted";
};
setmetatable(sasl_errstring, { __index = function() return "undefined error!" end });

local _ENV = nil;
-- luacheck: std none

local method = {};
method.__index = method;
local initialized = false;

local function init(service_name)
	if not initialized then
		local st, errmsg = pcall(cyrussasl.server_init, service_name);
		if st then
			initialized = true;
		else
			log("error", "Failed to initialize Cyrus SASL: %s", errmsg);
		end
	end
end

-- create a new SASL object which can be used to authenticate clients
-- host_fqdn may be nil in which case gethostname() gives the value.
--      For GSSAPI, this determines the hostname in the service ticket (after
--      reverse DNS canonicalization, only if [libdefaults] rdns = true which
--      is the default).
local function new(realm, service_name, app_name, host_fqdn)

	init(app_name or service_name);

	local st, ret = pcall(cyrussasl.server_new, service_name, host_fqdn, realm, nil, nil)
	if not st then
		log("error", "Creating SASL server connection failed: %s", ret);
		return nil;
	end

	local sasl_i = { realm = realm, service_name = service_name, cyrus = ret };

	if cyrussasl.set_canon_cb then
		local c14n_cb = function (user)
			local node = s_match(user, "^([^@]+)");
			log("debug", "Canonicalizing username %s to %s", user, node)
			return node
		end
		cyrussasl.set_canon_cb(sasl_i.cyrus, c14n_cb);
	end

	cyrussasl.setssf(sasl_i.cyrus, 0, 0xffffffff)
	local mechanisms = {};
	local cyrus_mechs = cyrussasl.listmech(sasl_i.cyrus, nil, "", " ", "");
	for w in s_gmatch(cyrus_mechs, "[^ ]+") do
		mechanisms[w] = true;
	end
	sasl_i.mechs = mechanisms;
	return setmetatable(sasl_i, method);
end

-- get a fresh clone with the same realm and service name
function method:clean_clone()
	return new(self.realm, self.service_name)
end

-- get a list of possible SASL mechanims to use
function method:mechanisms()
	return self.mechs;
end

-- select a mechanism to use
function method:select(mechanism)
	if not self.selected and self.mechs[mechanism] then
		self.selected = mechanism;
		return true;
	end
end

-- feed new messages to process into the library
function method:process(message)
	local err;
	local data;

	if not self.first_step_done then
		err, data = cyrussasl.server_start(self.cyrus, self.selected, message or "")
		self.first_step_done = true;
	else
		err, data = cyrussasl.server_step(self.cyrus, message or "")
	end

	self.username = cyrussasl.get_username(self.cyrus)

	if (err == 0) then -- SASL_OK
		if self.require_provisioning and not self.require_provisioning(self.username) then
			return "failure", "not-authorized", "User authenticated successfully, but not provisioned for XMPP";
		end
		return "success", data
	elseif (err == 1) then -- SASL_CONTINUE
		return "challenge", data
	elseif (err == -4) then -- SASL_NOMECH
		log("debug", "SASL mechanism not available from remote end")
		return "failure", "invalid-mechanism", "SASL mechanism not available"
	elseif (err == -13) then -- SASL_BADAUTH
		return "failure", "not-authorized", sasl_errstring[err];
	else
		log("debug", "Got SASL error condition %d: %s", err, sasl_errstring[err]);
		return "failure", "undefined-condition", sasl_errstring[err];
	end
end

return {
	new = new;
};
