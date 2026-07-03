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

module:hook("muc-broadcast-presence", function(event)
	local traceparent = find_tag(event.stanza.tags, "traceparent")
	if not traceparent then
		return
	end

	local span = tracer:start_span("muc.presence", traceparent.attr)
			:set_attribute("room", otel.Attribute.string(event.room.jid))
			:set_attribute("from", otel.Attribute.string(event.stanza.attr.from))

	span:end_span()
end, -1)
