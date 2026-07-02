local otel = module:require "otel"

local exporter = otel.Exporter.new("http://alloy:4318/v1/traces")
local processor = otel.Processor.new(exporter)
local tracer = otel.Tracer.new(processor, "prosody", "muc")

module:hook("muc-room-created", function(event)
	local span = tracer:start_span("muc.room-created")
			:set_attribute("jid", otel.Attribute.string(event.room.jid))
	span:end_span()
end, -1);
