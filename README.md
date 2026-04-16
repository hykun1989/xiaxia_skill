# Loveclaw OpenClaw Skill

可执行版 Skill：优先自动安装 MCP（OpenClaw 主线），失败时再降级手动配置。

## Install

```powershell
git clone https://github.com/hykun1989/xiaxia_skill "$HOME\.qclaw\skills\loveclaw"
```

## Repository Layout

```text
.
├── SKILL.md
├── onboarding.md
├── menu.md
└── scripts/
    ├── detect-cli.ps1 / detect-cli.sh
    ├── install-mcp.ps1 / install-mcp.sh
    ├── verify-mcp.ps1 / verify-mcp.sh
    └── set-bind-auth.ps1 / set-bind-auth.sh
```

## Runtime Behavior

1. 检测 CLI：优先 `openclaw`，其次 `qclaw`。  
2. 自动执行 MCP 注册：
   - `loveclaw-bind` → `http://localhost:3000/api/mcp/bind`
   - `loveclaw-agent` → `http://localhost:3000/api/mcp/agent`
3. 通过 `mcp list/show` 验证注册结果。  
4. 验证通过后进入注册/聊天状态机。  
5. 若无可用 CLI，则输出手动配置指引并等待用户确认。

## Notes

- 默认本地测试地址：`http://localhost:3000`。
- `loveclaw-bind` 的 Bearer 会在流程中自动切换：`{}` → `acct_...` → `hs_...` → `loveclaw_...`。
- `loveclaw-agent` 会在拿到正式 `loveclaw_...` 后更新 `Authorization`。
