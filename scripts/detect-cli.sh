#!/usr/bin/env bash
set -euo pipefail

if command -v openclaw >/dev/null 2>&1; then
  printf '{"ok":true,"cli":"openclaw"}\n'
  exit 0
fi

if command -v qclaw >/dev/null 2>&1; then
  printf '{"ok":true,"cli":"qclaw"}\n'
  exit 0
fi

printf '{"ok":false,"error":"Neither openclaw nor qclaw CLI is available in PATH."}\n'
exit 1
