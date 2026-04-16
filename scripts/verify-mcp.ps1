param(
  [string]$Cli = "openclaw"
)

$ErrorActionPreference = "Stop"

& $Cli mcp list
& $Cli mcp show loveclaw-bind
& $Cli mcp show loveclaw-agent
Write-Output "Verified MCP servers via $Cli"
