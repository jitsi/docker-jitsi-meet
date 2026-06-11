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

local function on_message(event)
  local _, stanza = event.origin, event.stanza;
  local request_message = stanza:get_child('json-message', 'http://jitsi.org/jitmeet')
      or stanza:get_child('json-message');
  if not request_message then
    return;
  end
  local request_data, _ = json.decode(request_message:get_text());

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
            spans = {}
          }
        }
      }
    },
  }

  local span = {
    traceId = generate_trace_id(),
    spanId = generate_span_id(),
    name = request_data.command,
    kind = 2,
    startTimeUnixNano = string.format("%.0f", os.time() * 1e9),
    endTimeUnixNano = string.format("%.0f", (os.time() + 1) * 1e9),
    status = { code = 1 },
    attributes = {
      {
        key = "from",
        value = { stringValue = stanza.attr.from }
      },
    }
  }

  table.insert(span.attributes,
    {
      key = "pollId",
      value = { stringValue = request_data.pollId }
    }
  )

  if request_data.command == "new-poll" then
    table.insert(span.attributes, {
      key = "question",
      value = { stringValue = request_data.question }
    })
    local options = {}
    for _, v in ipairs(request_data.answers) do
      table.insert(options, { stringValue = v.name })
    end
    table.insert(span.attributes, {
      key = "options",
      value = { arrayValue = { values = options } }
    })
  end

  if request_data.command == "answer-poll" then
    local answers = {}
    for _, v in ipairs(request_data.answers) do
      table.insert(answers, { boolValue = v })
    end
    table.insert(span.attributes, {
      key = "answers",
      value = { arrayValue = { values = answers } }
    })
  end

  table.insert(trace_data.resourceSpans[1].scopeSpans[1].spans, span)

  http.request(
    "http://alloy:4318/v1/traces",
    {
      method = "POST",
      headers = { ["Content-Type"] = "application/json" },
      body = json.encode(trace_data)
    },
    function() end
  )
end

module:hook("message/host", on_message, 1000);
