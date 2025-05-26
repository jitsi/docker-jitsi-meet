module:set_global();

local ip = require "util.ip";

local modulemanager = require "core.modulemanager";

local permitted_ips = module:get_option_set("http_health_allow_ips", { "::1", "127.0.0.1" });
local permitted_cidr = module:get_option_string("http_health_allow_cidr");

local function is_permitted(request)
	local ip_raw = request.ip;
	if permitted_ips:contains(ip_raw) or
	   (permitted_cidr and ip.match(ip.new_ip(ip_raw), ip.parse_cidr(permitted_cidr))) then
		return true;
	end
	return false;
end

module:provides("http", {
	route = {
		GET = function(event)
			local request = event.request;
			if not is_permitted(request) then
				return 403; -- Forbidden
			end

			for host in pairs(prosody.hosts) do
				local mods = modulemanager.get_modules(host);
				for _, mod in pairs(mods) do
					if mod.module.status_type == "error" then
						return { status_code = 500; headers = { content_type = "text/plain" }; body = "HAS ERRORS\n" };
					end
				end
			end

			return { status_code = 200; headers = { content_type = "text/plain" }; body = "OK\n" };
		end;
	};
});
