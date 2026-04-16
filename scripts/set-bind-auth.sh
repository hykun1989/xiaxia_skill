#!/usr/bin/env bash
set -euo pipefail

CLI="${1:-openclaw}"
TARGET="${2:-bind}" # bind | agent
BASE_URL="${3:-http://localhost:3000}"
TOKEN="${4:-}"

if [[ "$TARGET" == "bind" ]]; then
  NAME="loveclaw-bind"
  URL="$BASE_URL/api/mcp/bind"
else
  NAME="loveclaw-agent"
  URL="$BASE_URL/api/mcp/agent"
fi

if [[ -n "$TOKEN" ]]; then
  JSON="$(printf '{"url":"%s","transport":"streamable-http","headers":{"Authorization":"Bearer %s"}}' "$URL" "$TOKEN")"
else
  JSON="$(printf '{"url":"%s","transport":"streamable-http","headers":{}}' "$URL")"
fi

"$CLI" mcp set "$NAME" "$JSON"
echo "Updated $NAME headers via $CLI"
