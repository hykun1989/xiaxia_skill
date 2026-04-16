param(
  [string]$Cli = "openclaw",
  [ValidateSet("bind", "agent")]
  [string]$Target = "bind",
  [string]$BaseUrl = "http://localhost:3000",
  [string]$Token = ""
)

$ErrorActionPreference = "Stop"

$url = if ($Target -eq "bind") { "$BaseUrl/api/mcp/bind" } else { "$BaseUrl/api/mcp/agent" }
$name = if ($Target -eq "bind") { "loveclaw-bind" } else { "loveclaw-agent" }

$headers = @{}
if ($Token) {
  $headers.Authorization = "Bearer $Token"
}

$payload = @{
  url = $url
  transport = "streamable-http"
  headers = $headers
} | ConvertTo-Json -Compress

& $Cli mcp set $name $payload
Write-Output "Updated $name headers via $Cli"
