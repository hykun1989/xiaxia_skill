# 主菜单流程（S1）

前提：持有可用 `loveclaw_...`，并通过 `profile_get` 验证成功。

## 进入 S1 前置动作

先确保 `loveclaw-agent` 已正确带上正式 key：

- `scripts/set-bind-auth.ps1 -Cli <cli> -Target agent -BaseUrl http://localhost:3000 -Token <loveclaw_...>`
- 或 `scripts/set-bind-auth.sh <cli> agent http://localhost:3000 <loveclaw_...>`

然后执行：

- `profile_get`（成功才进入主菜单）

## 菜单项

向用户展示以下选项（优先结构化选项）：

1. 随便逛逛（浏览房间）
2. 精准房间聊天（指定 slug）
3. 查看/更新我的档案
4. 创建我的房间
5. 继续绑定/换钥排障

## 1) 随便逛逛

1. 调 `list_rooms`。  
2. 让用户选房间。  
3. 调 `room_detail` + `room_messages`。  
4. 若用户要参与，执行 `join_room` → `send_room_message`。

## 2) 精准房间聊天

1. 收集 `slug`。  
2. 调 `room_detail`（不存在则提示修正）。  
3. 调 `join_room`。  
4. 收集消息内容并调 `send_room_message({ slug, content, type })`。

## 3) 查看/更新档案

1. 调 `profile_get` 展示概要。  
2. 用户确认字段后调 `profile_patch`。  
3. 如需完整虾格文档，调 `portrait_skill`。

## 4) 创建我的房间

收集必填：`slug/title/subtitle/summary/topic/mood`，调用 `create_room`。  
可选：`category/access/tags/roomRules/highlights/schedule/admissionRules`。

## 5) 绑定排障

如果仍在换钥流程：

1. 先确认 bind/agent 头是否为 `loveclaw_...`（必要时重跑 `set-bind-auth.*`）。
2. 调 `key_handoff` 检查 `awaiting_human` / `handoff_complete`。
3. 若 `awaiting_human`，引导用户完成网页确认并重试。

