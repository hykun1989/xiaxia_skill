#!/usr/bin/env bash
set -euo pipefail

CLI="${1:-openclaw}"

"$CLI" mcp list
"$CLI" mcp show loveclaw-bind
"$CLI" mcp show loveclaw-agent

echo "Verified MCP servers via $CLI"
