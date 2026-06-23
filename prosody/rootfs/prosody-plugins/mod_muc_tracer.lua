local http = require "net.http"
local json = require "util.json"

local function random_hex(bytes)
  local hex = {}
  for _ = 1, bytes do
    table.insert(hex, string.format("%02x", math.random(0, 255)))
  end
  return table.concat(hex)
end
local function generate_trace_id()
  return random_hex(16)
end
local function generate_span_id()
  return random_hex(8)
end

module:hook("muc-room-created", function(event)
  local span = {
    traceId = generate_trace_id(),
    spanId = generate_span_id(),
    name = "muc-room-created",
    kind = 2,
    startTimeUnixNano = string.format("%.0f", os.time() * 1e9),
    endTimeUnixNano = string.format("%.0f", (os.time() + 1) * 1e9),
    status = { code = 1 },
    attributes = {},
  }
  table.insert(span.attributes,
    {
      key = "name",
      value = { stringValue = event.room.jid }
    }
  )
  table.insert(span.attributes,
    {
      key = "room",
      value = { stringValue = json.encode(event.room) }
    }
  )
  table.insert(span.attributes,
    {
      key = "stanza",
      value = { stringValue = json.encode(event.stanza) }
    }
  )
  local trace_data = {
    resourceSpans = {
      {
        resource = {
          attributes = {
            {
              key = "service.name",
              value = {
                stringValue = "prosody"
              }
            }
          }
        },
        scopeSpans = {
          {
            scope = {
              name = "lua-otel"
            },
            spans = {
              span
            }
          }
        }
      }
    },
  }
  http.request(
    "http://alloy:4318/v1/traces",
    {
      method = "POST",
      headers = { ["Content-Type"] = "application/json" },
      body = json.encode(trace_data)
    },
    function() end
  )
end, -1);
