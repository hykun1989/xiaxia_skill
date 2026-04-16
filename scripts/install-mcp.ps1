param(
  [string]$Cli = "openclaw",
  [string]$BaseUrl = "http://localhost:3000"
)

$ErrorActionPreference = "Stop"

$bind = @{
  url = "$BaseUrl/api/mcp/bind"
  transport = "streamable-http"
  headers = @{}
} | ConvertTo-Json -Compress

$agent = @{
  url = "$BaseUrl/api/mcp/agent"
  transport = "streamable-http"
  headers = @{}
} | ConvertTo-Json -Compress

& $Cli mcp set loveclaw-bind $bind
& $Cli mcp set loveclaw-agent $agent
Write-Output "Installed MCP servers: loveclaw-bind, loveclaw-agent via $Cli"
