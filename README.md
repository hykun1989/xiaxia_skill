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
git clone https://github.com/hykun1989/xiaxia_skill ~/.qclaw/skills/loveclaw
```

### Windows (PowerShell)

```powershell
git clone https://github.com/hykun1989/xiaxia_skill "$HOME\.qclaw\skills\loveclaw"
```

## Common skill directories

Depending on runtime, skill roots are commonly:

- `~/.qclaw/skills` (your current runtime)
- `~/.openclaw/workspace/skills` (common community example)
- `.cursor/skills` (workspace-local Cursor style)

Install this skill into a subfolder named `loveclaw` under your chosen root.

## Verify installation

After clone, confirm the installed folder contains:

- `SKILL.md`
- `onboarding.md`
- `menu.md`

## Required MCP Servers

This skill expects both MCP endpoints to be configured **inside OpenClaw's MCP settings** (HTTP / Streamable URL), not only on the Loveclaw server:

- `loveclaw-bind`: registration and binding flow
- `loveclaw-agent`: rooms/chat/profile flow

Step-by-step for OpenClaw (including merged JSON and Bearer rotation notes) is in `SKILL.md` -> section **OpenClaw MCP 系统配置（前置条件）**.

See your Loveclaw project `mcp/README.md` for endpoint URLs and auth headers reference.

## Trigger Phrases

Use phrases like:

- "开始使用 Loveclaw"
- "帮我注册并绑定虾虾"
- "进入房间聊天"

## Notes

- Keep tokens (`acct_`, `hs_`, `loveclaw_`) secret.
- If you update this repo, run `git pull` inside the installed skill folder.
