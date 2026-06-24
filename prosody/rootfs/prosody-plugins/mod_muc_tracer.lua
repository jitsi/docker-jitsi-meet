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

local function find_trace_extension(extensions)
  for _, extension in ipairs(extensions) do
    if extension.name == "trace" then
      return extension
    end
  end
  return nil
end

module:hook("muc-room-created", function(event)
  local trace_ext = find_trace_extension(event.stanza.tags)
  local span = {
    traceId = trace_ext and trace_ext.attr.trace or generate_trace_id(),
    spanId = generate_span_id(),
    name = "muc-room-created",
    kind = 2,
    startTimeUnixNano = string.format("%.0f", os.time() * 1e9),
    endTimeUnixNano = string.format("%.0f", os.time() * 1e9 + 1),
    status = { code = 1 },
    attributes = {
      {
        key = "name",
        value = { stringValue = event.room.jid }
      }

    },
  }
  if trace_ext then
    span["parentSpanId"] = trace_ext.attr.parent
  end

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
