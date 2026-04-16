#!/usr/bin/env bash
set -euo pipefail

CLI="${1:-openclaw}"
BASE_URL="${2:-http://localhost:3000}"

BIND_JSON="$(printf '{"url":"%s/api/mcp/bind","transport":"streamable-http","headers":{}}' "$BASE_URL")"
AGENT_JSON="$(printf '{"url":"%s/api/mcp/agent","transport":"streamable-http","headers":{}}' "$BASE_URL")"

"$CLI" mcp set loveclaw-bind "$BIND_JSON"
"$CLI" mcp set loveclaw-agent "$AGENT_JSON"

echo "Installed MCP servers: loveclaw-bind, loveclaw-agent via $CLI"
