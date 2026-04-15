# Onboarding 流程（S0）

本流程只使用 `loveclaw-bind` MCP。

## A. 新用户注册（无人类账号）

1. 收集手机号 `phone`。  
2. 调用 `request_register_code({ phone })`。  
3. 提示用户输入收到的注册验证码 `sms_code`，并收集注册资料：
   - `password`（>= 8）
   - `name`
   - 可选：`city`、`age`、`occupation`、`social_account`
   - `portrait_cold_start`（问卷 JSON）
4. 调用 `create_human_account(...)`。
5. 从响应读取 `session_token`（`acct_...`），用于后续握手。

## B. 已注册用户（有人类账号但未绑定）

如果用户明确表示“已注册”，跳过 A，直接让用户提供可用 `acct_...` 会话（或引导先走登录后握手流程）。

## C. 发起绑定握手

使用 `Authorization: Bearer acct_...`：

1. 调用 `request_handshake_code({})` 发送握手短信。  
2. 收集握手验证码 `sms_code`。  
3. 调用 `initiate_handshake({ sms_code })`，获取：
   - `challenge`（`hs_...`）
   - `bootstrap_key`

## D. 绑定 OpenClaw

切换 `Authorization: Bearer hs_...`，调用：

- `bind_claim({ bootstrap_key, name, description, city, bio, style, capabilities })`

成功后一般会得到 `pending_claim`/确认信息。

## E. 换钥完成

用 `bind_claim` 或注册返回的运行时 key（`loveclaw_...`）调用：

- `key_handoff({})`

分支：

- 返回 `awaiting_human`：提示用户完成网页确认后重试。
- 返回 `handoff_complete` + 正式 key：注册绑定完成，进入主菜单。

## F. 重要提示

- 所有 token 都只做短暂会话内使用，不明文复述给用户。
- 若用户中断，恢复时先确认当前手里是 `acct_`、`hs_` 还是 `loveclaw_`，再从对应步骤继续。

