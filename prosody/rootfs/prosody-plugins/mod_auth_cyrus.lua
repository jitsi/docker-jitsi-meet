-- Prosody IM
-- Copyright (C) 2008-2010 Matthew Wild
-- Copyright (C) 2008-2010 Waqas Hussain
--
-- This project is MIT/X11 licensed. Please see the
-- COPYING file in the source package for more information.
--
-- luacheck: ignore 212

local log = require "util.logger".init("auth_cyrus");

local usermanager_user_exists = require "core.usermanager".user_exists;

local cyrus_service_realm = module:get_option("cyrus_service_realm");
local cyrus_service_name = module:get_option("cyrus_service_name");
local cyrus_application_name = module:get_option("cyrus_application_name");
local require_provisioning = module:get_option("cyrus_require_provisioning") or false;
local host_fqdn = module:get_option("cyrus_server_fqdn");

prosody.unlock_globals(); --FIXME: Figure out why this is needed and
						  -- why cyrussasl isn't caught by the sandbox
local cyrus_new = module:require "sasl_cyrus".new;
prosody.lock_globals();
local new_sasl = function(realm)
	return cyrus_new(
		cyrus_service_realm or realm,
		cyrus_service_name or "xmpp",
		cyrus_application_name or "prosody",
		host_fqdn
	);
end

do -- diagnostic
	local list;
	for mechanism in pairs(new_sasl(module.host):mechanisms()) do
		list = (not(list) and mechanism) or (list..", "..mechanism);
	end
	if not list then
		module:log("error", "No Cyrus SASL mechanisms available");
	else
		module:log("debug", "Available Cyrus SASL mechanisms: %s", list);
	end
end

local host = module.host;

-- define auth provider
local provider = {};
log("debug", "initializing default authentication provider for host '%s'", host);

function provider.test_password(username, password)
	return nil, "Legacy auth not supported with Cyrus SASL.";
end

function provider.get_password(username)
	return nil, "Passwords unavailable for Cyrus SASL.";
end

function provider.set_password(username, password)
	return nil, "Passwords unavailable for Cyrus SASL.";
end

function provider.user_exists(username)
	if require_provisioning then
		return usermanager_user_exists(username, host);
	end
	return true;
end

function provider.create_user(username, password)
	return nil, "Account creation/modification not available with Cyrus SASL.";
end

function provider.get_sasl_handler()
	local handler = new_sasl(host);
	if require_provisioning then
		function handler.require_provisioning(username)
			return usermanager_user_exists(username, host);
		end
	end
	return handler;
end

module:provides("auth", provider);

