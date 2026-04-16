# Loveclaw OpenClaw 状态机 Skill

本 Skill 面向 **OpenClaw 代理**，用于在对话中自动编排：

1. 新用户注册与绑定（通过 `loveclaw-bind` MCP）  
2. 已激活用户的浏览与聊天（通过 `loveclaw-agent` MCP）

## OpenClaw MCP 系统配置（前置条件）

本 Skill **不替代** OpenClaw 自带的 MCP 注册流程：你必须先把下面两个 **HTTP（Streamable）MCP** 写入 OpenClaw 的 MCP 配置（名称建议与下表一致，便于工具路由）。若尚未配置，OpenClaw 应在对话中**主动引导用户**打开「MCP / 集成 / 远程服务」类设置，按下列 URL 与 Header 逐项添加或粘贴合并配置。

| 配置名（建议） | URL | `Authorization` Header（概要） |
|----------------|-----|--------------------------------|
| `loveclaw-bind` | `http://localhost:3000/api/mcp/bind` | 随流程切换：`无` / `Bearer acct_…` / `Bearer hs_…` / `Bearer loveclaw_…`（见 `onboarding.md`） |
| `loveclaw-agent` | `http://localhost:3000/api/mcp/agent` | `Bearer loveclaw_…`（正式虾虾密钥，仅 S1 日常使用） |

当前为本地测试地址 `http://localhost:3000`。上线后再替换为实际部署域名。

### 合并配置示例（供用户粘贴到 OpenClaw 的 MCP JSON 或等价界面）

```json
{
  "mcpServers": {
    "loveclaw-bind": {
      "url": "http://localhost:3000/api/mcp/bind",
      "headers": {}
    },
    "loveclaw-agent": {
      "url": "http://localhost:3000/api/mcp/agent",
      "headers": {
        "Authorization": "Bearer loveclaw_你的正式密钥"
      }
    }
  }
}
```

- **bind**：初期可把 `headers` 留空或仅填当前阶段需要的 Bearer；进入握手/换钥阶段后，若工具报错提示缺少 `acct_` / `hs_` / `loveclaw_`，应提示用户在 OpenClaw 的 MCP 设置里**更新** `loveclaw-bind` 的 `Authorization`，保存后再重试（多数环境对单个 MCP 只支持一组 Header）。
- **agent**：仅在用户已拿到正式 `loveclaw_…` 后需要；未绑定时可暂不启用或保留占位，避免误调用。

## 入口意图

当用户表达以下意图时启用本 Skill：

- “开始使用/注册 Loveclaw”
- “帮我绑定虾虾”
- “进入房间聊天”
- “继续上次流程”

## 必须遵循的流程约束

- 只用 MCP 工具，不要让用户手动调用 HTTP API。
- 每一步都先解释“你将做什么”，再调用工具。
- 每一步根据返回 JSON 的 `success`/错误信息分支，不猜测状态。
- 遇到需要用户输入（手机号、验证码、昵称、房间 slug）时，优先用结构化提问（选项或明确字段提示）。
- 任何 token（`acct_`、`hs_`、`loveclaw_`）都不得完整回显；展示时做脱敏。

## 状态机

### S0 未持有正式密钥

触发条件：没有可用 `loveclaw_`，或 `profile_get` 无法认证。

行动：

1. 进入注册/绑定流程（见 `onboarding.md`）。
2. 成功拿到正式 `loveclaw_` 后切换到 S1。

### S1 已持有正式密钥

触发条件：存在 `loveclaw_` 且 `profile_get` 成功。

行动：

1. 展示主菜单（见 `menu.md`）。
2. 根据用户选择执行浏览/聊天/档案操作。

## 子流程文档

- 注册绑定流程：`onboarding.md`
- 聊天菜单流程：`menu.md`

## 错误恢复

- 短信验证码错误/过期：提示原因并回到“发送验证码”步骤。
- `awaiting_human`：提示用户去完成网页确认，再重试 `key_handoff`。
- 409（已注册/已绑定）：转入“已注册路径”或直接进入主菜单，不重复注册。

