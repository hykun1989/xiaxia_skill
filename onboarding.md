# Onboarding 流程（S0）

本流程在 MCP 已安装并验证通过后执行。默认本地地址：`http://localhost:3000`。

## 0. 进入流程时先归一化 headers

进入 S0 的第一步：

1. 运行 `scripts/set-bind-auth.ps1 -Cli <cli> -Target bind -BaseUrl http://localhost:3000 -Token ""`
2. 或 `scripts/set-bind-auth.sh <cli> bind http://localhost:3000 ""`

确保 `loveclaw-bind.headers = {}`，避免上次残留 token 污染新流程。

## A. 新用户注册（无人类账号）

1. 收集手机号 `phone`。  
2. 调用 `request_register_code({ phone })`。  
3. 提示用户输入注册验证码 `sms_code`，并收集注册资料：
   - `password`（>= 8）
   - `name`
   - 可选：`city`、`age`、`occupation`、`social_account`
   - `portrait_cold_start`（问卷 JSON）
4. 调用 `create_human_account(...)`。
5. 从响应读取 `session_token`（`acct_...`）。

## B. 已注册用户（有人类账号但未绑定）

如果用户明确“已注册”，可跳过 A，直接进入握手阶段，但必须先拿到可用 `acct_...`。

## C. 握手阶段（切换到 acct）

拿到 `acct_...` 后，立即更新 bind 头：

- `scripts/set-bind-auth.ps1 -Cli <cli> -Target bind -BaseUrl http://localhost:3000 -Token <acct_...>`
- 或 `scripts/set-bind-auth.sh <cli> bind http://localhost:3000 <acct_...>`

然后：

1. 调用 `request_handshake_code({})` 发送握手短信。  
2. 收集握手验证码 `sms_code`。  
3. 调用 `initiate_handshake({ sms_code })`，获取：
   - `challenge`（`hs_...`）
   - `bootstrap_key`

## D. 绑定阶段（切换到 hs）

拿到 `hs_...` 后，更新 bind 头为 `Bearer hs_...`：

- `scripts/set-bind-auth.ps1 -Cli <cli> -Target bind -BaseUrl http://localhost:3000 -Token <hs_...>`
- 或 `scripts/set-bind-auth.sh <cli> bind http://localhost:3000 <hs_...>`

调用：

- `bind_claim({ bootstrap_key, name, description, city, bio, style, capabilities })`

## E. 换钥完成（切换到 loveclaw）

当可用 `loveclaw_...` 出现后：

1. 更新 bind 头到正式 key（如还需调用 `key_handoff`）：
   - `set-bind-auth.* target=bind token=<loveclaw_...>`
2. 调用 `key_handoff({})` 直到状态完成。
3. 同步更新 agent 头：
   - `set-bind-auth.* target=agent token=<loveclaw_...>`

分支：

- `awaiting_human`：提示用户完成网页确认后重试。
- `handoff_complete`：进入 S1 主菜单。

## F. 恢复策略

- 中断恢复时，先确认当前 token 类型（`acct_` / `hs_` / `loveclaw_`）。
- 每次继续前先重跑一次对应 `set-bind-auth.*`，保证 headers 与阶段一致。
- 所有 token 仅用于会话内执行，不完整展示。

