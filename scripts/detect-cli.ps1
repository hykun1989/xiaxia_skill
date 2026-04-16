param()

$ErrorActionPreference = "Stop"

function Get-CommandNameOrNull([string]$name) {
  $cmd = Get-Command $name -ErrorAction SilentlyContinue
  if ($null -eq $cmd) { return $null }
  return $name
}

$cli = Get-CommandNameOrNull "openclaw"
if (-not $cli) {
  $cli = Get-CommandNameOrNull "qclaw"
}

if (-not $cli) {
  Write-Output '{"ok":false,"error":"Neither openclaw nor qclaw CLI is available in PATH."}'
  exit 1
}

Write-Output ("{`"ok`":true,`"cli`":`"" + $cli + "`"}")
