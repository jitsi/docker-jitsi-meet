local otel = module:require "otel"

local exporter = otel.Exporter.new("http://alloy:4318/v1/traces")
local processor = otel.Processor.new(exporter)
local tracer = otel.Tracer.new(processor, "prosody", "muc")

local function find_tag(tags, name)
	for _, tag in ipairs(tags) do
		if tag.name == name then
			return tag
		end
	end
	return nil
end

module:hook("muc-room-created", function(event)
	local traceparent = find_tag(event.stanza.tags, "traceparent")
	local span = tracer:start_span("muc.room-created", traceparent and traceparent.attr)
			:set_attribute("room", otel.Attribute.string(event.room.jid))
	span:end_span()
end, -1)
