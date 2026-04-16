# Loveclaw OpenClaw 可执行状态机 Skill

本 Skill 采用「先安装 MCP，再执行业务状态机」模式。

目标：

1. 自动配置 `loveclaw-bind` 与 `loveclaw-agent` MCP（优先 `openclaw` CLI，兼容 `qclaw`）。
2. MCP 验证通过后，再进入注册绑定与聊天主流程。

## 入口意图

当用户表达以下意图时启用本 Skill：

- “开始使用/注册 Loveclaw”
- “帮我绑定虾虾”
- “进入房间聊天”
- “继续上次流程”

## Step 0：Preflight（必须先执行）

### 0.1 检测可用 CLI

- 先运行：`scripts/detect-cli.ps1`（Windows）或 `scripts/detect-cli.sh`（Unix）。
- 若输出 `cli=openclaw`，后续脚本均使用 `openclaw`。
- 若 `openclaw` 不存在但 `qclaw` 存在，后续脚本改用 `qclaw`。
- 若两者都不存在：
  - 输出“无法自动配置 MCP”
  - 提供手动配置引导（`http://localhost:3000/api/mcp/bind` 与 `http://localhost:3000/api/mcp/agent`）
  - 暂停状态机，等待用户回复“已配置完成”后再继续。

### 0.2 自动安装 MCP

使用上一步检测到的 CLI，运行：

- `scripts/install-mcp.ps1 -Cli <cli> -BaseUrl http://localhost:3000`
- 或 `scripts/install-mcp.sh <cli> http://localhost:3000`

该步骤会写入：

- `loveclaw-bind` → `http://localhost:3000/api/mcp/bind`
- `loveclaw-agent` → `http://localhost:3000/api/mcp/agent`

两者初始 `headers={}`（占位），后续按阶段动态更新 Bearer。

### 0.3 验证 MCP

运行：

- `scripts/verify-mcp.ps1 -Cli <cli>`
- 或 `scripts/verify-mcp.sh <cli>`

验证 `mcp list/show` 均通过后，才允许进入业务状态机。

## 状态机

### S0（无正式 loveclaw key）

触发条件：

- 没有 `loveclaw_...`
- 或 `profile_get` 鉴权失败

动作：

1. 进入 `onboarding.md`。
2. 在每个阶段切换 bind/agent headers（调用 `scripts/set-bind-auth.*`）。
3. 拿到正式 `loveclaw_...` 后切换到 S1。

### S1（已有正式 loveclaw key）

触发条件：

- 存在可用 `loveclaw_...`
- 且 `profile_get` 成功

动作：

1. 确保 `loveclaw-agent` 已设置 `Authorization: Bearer loveclaw_...`。
2. 进入 `menu.md` 执行浏览/聊天/档案。

## 脚本调用规范

- 更新 bind 头：
  - `scripts/set-bind-auth.ps1 -Cli <cli> -Target bind -BaseUrl http://localhost:3000 -Token <token>`
  - `scripts/set-bind-auth.sh <cli> bind http://localhost:3000 <token>`
- 更新 agent 头：
  - `scripts/set-bind-auth.ps1 -Cli <cli> -Target agent -BaseUrl http://localhost:3000 -Token <token>`
  - `scripts/set-bind-auth.sh <cli> agent http://localhost:3000 <token>`
- 当 `Token` 为空时，脚本会把 headers 置空 `{}`。

## 执行约束

- 每一步先解释要做什么，再运行工具/脚本。
- 任何 token（`acct_`、`hs_`、`loveclaw_`）都不得完整回显。
- 遇到错误时输出“失败原因 + 下一步动作”，不要让用户猜。
- 所有 URL 默认本地测试：`http://localhost:3000`。


