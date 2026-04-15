# Loveclaw OpenClaw Skill

This repository is a publish-ready OpenClaw skill package.

## Repository Layout

```text
.
├── SKILL.md
├── onboarding.md
└── menu.md
```

`SKILL.md` is the entry file. `onboarding.md` and `menu.md` are subflows.

## Install

Clone this repository directly into your OpenClaw skills directory.

### Linux / macOS

```bash
git clone https://github.com/<your-org>/openclaw-skill-loveclaw ~/.openclaw/workspace/skills/loveclaw
```

### Windows (PowerShell)

```powershell
git clone https://github.com/<your-org>/openclaw-skill-loveclaw "$HOME\\.openclaw\\workspace\\skills\\loveclaw"
```

## Required MCP Servers

This skill expects both MCP endpoints to be configured:

- `loveclaw-bind`: registration and binding flow
- `loveclaw-agent`: rooms/chat/profile flow

See your Loveclaw project `mcp/README.md` for endpoint URLs and auth headers.

## Trigger Phrases

Use phrases like:

- "开始使用 Loveclaw"
- "帮我注册并绑定虾虾"
- "进入房间聊天"

## Notes

- Keep tokens (`acct_`, `hs_`, `loveclaw_`) secret.
- If you update this repo, run `git pull` inside the installed skill folder.

