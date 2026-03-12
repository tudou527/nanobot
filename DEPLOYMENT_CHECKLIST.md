# Nanobot CapRover 部署清单

## 📋 部署前准备

### 1. GitHub Secrets 配置

在 GitHub 仓库 `Settings` → `Secrets and variables` → `Actions` 中配置：

- [ ] `CAPROVER_SERVER` - CapRover 服务器地址（如 `https://captain.your-domain.com`）
- [ ] `APP_NAME` - 应用名称（如 `nanobot`）
- [ ] `APP_TOKEN` - CapRover 应用 Token

### 2. CapRover 应用创建

- [ ] 在 CapRover 中创建新应用，命名为 `nanobot`
- [ ] 获取应用 Token（App Configs → Deployment → App Token）

---

## 🚀 首次部署

### 1. 触发 GitHub Actions

- [ ] 进入 GitHub 仓库的 `Actions` 标签页
- [ ] 选择 `Deploy to CapRover` 工作流
- [ ] 点击 `Run workflow`
- [ ] 选择版本（默认 `main`）
- [ ] 等待部署完成（约 5-10 分钟）

---

## ⚙️ CapRover 应用配置

### 1. 持久化目录配置

在 CapRover 应用的 `App Configs` → `Persistent Directories` 中添加：

| 路径 | 标签 | 说明 |
|------|------|------|
| `/root/.nanobot` | `nanobot-data` | Nanobot 配置和数据目录 |

**操作步骤**：
- [ ] 点击 `Add Persistent Directory`
- [ ] Path in App: `/root/.nanobot`
- [ ] Label: `nanobot-data`
- [ ] 点击 `Save & Update`

### 2. 端口映射配置

在 CapRover 应用的 `HTTP Settings` 中配置：

| 配置项 | 值 | 说明 |
|--------|-----|------|
| Container HTTP Port | `18790` | Nanobot Gateway 服务端口 |
| Enable HTTPS | ✅ | 启用 HTTPS |
| Force HTTPS | ✅ | 强制使用 HTTPS |
| Websocket Support | ✅ | 启用 WebSocket（如需要） |

**操作步骤**：
- [ ] Container HTTP Port 设置为 `18790`
- [ ] 勾选 `Enable HTTPS`
- [ ] 勾选 `Force HTTPS by redirecting all HTTP traffic to HTTPS`
- [ ] 如需 WebSocket 支持，勾选 `Websocket Support`
- [ ] 点击 `Save & Update`

### 3. 环境变量配置

在 CapRover 应用的 `App Configs` → `Environment Variables` 中添加：

#### 必需的环境变量

根据你使用的 LLM 提供商，至少配置以下之一：

| 变量名 | 示例值 | 说明 |
|--------|--------|------|
| `OPENAI_API_KEY` | `sk-proj-xxxxx` | OpenAI API 密钥 |
| `DASHSCOPE_API_KEY` | `sk-xxxxx` | 阿里云 DashScope API 密钥（通义千问） |

#### 可选的环境变量

| 变量名 | 示例值 | 说明 |
|--------|--------|------|
| `ANTHROPIC_API_KEY` | `sk-ant-xxxxx` | Anthropic Claude API 密钥 |
| `GOOGLE_API_KEY` | `AIzaSyxxxxx` | Google Gemini API 密钥 |
| `DEEPSEEK_API_KEY` | `sk-xxxxx` | DeepSeek API 密钥 |
| `OPENROUTER_API_KEY` | `sk-or-xxxxx` | OpenRouter API 密钥 |

**操作步骤**：
- [ ] 点击 `Add Key-Value`
- [ ] 输入变量名和值
- [ ] 点击 `Add`
- [ ] 添加完所有变量后，点击 `Save & Update`

### 4. 域名配置（可选）

在 CapRover 应用的 `HTTP Settings` → `Domain` 中配置：

- [ ] 添加自定义域名（如 `nanobot.your-domain.com`）
- [ ] 启用 HTTPS
- [ ] 等待 SSL 证书自动配置

---

## 🔧 初始化配置

部署完成后，需要初始化 Nanobot 配置：

### 方式 1：通过 CapRover Console（推荐）

- [ ] 在 CapRover 中进入 `nanobot` 应用
- [ ] 点击 `App Configs` → `Deployment` → `Execute Command`
- [ ] 执行命令：`nanobot onboard`
- [ ] 按照提示配置：
  - [ ] 选择 LLM 提供商
  - [ ] 输入 API Keys
  - [ ] 配置其他选项

### 方式 2：手动上传配置文件

如果已有 `config.json` 文件：

- [ ] 在 CapRover 中进入 `nanobot` 应用
- [ ] 使用 SSH 或 File Manager 上传到 `/root/.nanobot/config.json`
- [ ] 重启应用

---

## ✅ 验证部署

### 1. 检查应用状态

- [ ] 在 CapRover 中查看应用状态为 `Running`
- [ ] 查看应用日志，确认无错误

### 2. 测试 API 端点

```bash
curl https://nanobot.your-domain.com/health
```

预期返回：
```json
{"status": "ok"}
```

- [ ] API 端点可访问
- [ ] 返回正常响应

### 3. 测试 Gateway 服务

在 CapRover Console 中执行：
```bash
nanobot status
```

- [ ] 命令执行成功
- [ ] 显示配置信息

### 4. 配置聊天平台（可选）

根据需要配置以下平台之一：

- [ ] Telegram Bot
- [ ] Discord Bot
- [ ] Slack Bot
- [ ] QQ 频道（需要在 config.json 中配置 appId 和 secret）
- [ ] WhatsApp（需要额外配置）

**QQ 频道配置示例**：
```json
{
  "channels": {
    "qq": {
      "enabled": true,
      "appId": "你的QQ机器人AppId",
      "secret": "你的QQ机器人Secret",
      "allowFrom": [""]
    }
  }
}
```

### 5. 发送测试消息

- [ ] 在配置的聊天平台发送测试消息
- [ ] 验证 Bot 正常响应

---

## 📝 配置文件结构

部署完成后，`/root/.nanobot/` 目录结构：

```
/root/.nanobot/
├── config.json          # 主配置文件
├── workspace/           # Agent 工作空间
├── media/              # 媒体文件
├── cron/               # 定时任务
├── logs/               # 日志文件
├── bridge/             # WhatsApp bridge
├── sessions/           # 会话数据
└── history/            # CLI 历史
```

---

## 🔄 后续更新

当需要更新 Nanobot 版本时：

- [ ] 进入 GitHub Actions
- [ ] 运行 `Deploy to CapRover` 工作流
- [ ] 选择新版本号或使用 `main`
- [ ] 等待部署完成
- [ ] 验证应用正常运行

**注意**：配置文件和数据会保留，不会丢失。

---

## 🐛 故障排查

### 部署失败

- [ ] 检查 GitHub Actions 日志
- [ ] 确认 GitHub Secrets 配置正确
- [ ] 确认 CapRover 服务器可访问
- [ ] 检查 CapRover App Token 是否有效

### 应用无法启动

- [ ] 查看 CapRover 应用日志
- [ ] 检查环境变量配置
- [ ] 确认持久化目录已正确挂载
- [ ] 检查配置文件格式是否正确

### 无法访问服务

- [ ] 检查端口映射配置（18790）
- [ ] 确认 HTTPS 已启用
- [ ] 检查防火墙规则
- [ ] 验证域名 DNS 解析

### API 调用失败

- [ ] 检查 API Keys 是否正确配置
- [ ] 查看应用日志中的错误信息
- [ ] 验证 API Keys 是否有效且有足够额度

---

## 📞 获取帮助

- [Nanobot 官方文档](https://github.com/HKUDS/nanobot)
- [CapRover 文档](https://caprover.com/docs/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

---

## ✨ 部署完成

恭喜！如果以上所有步骤都已完成并验证通过，你的 Nanobot 已成功部署到 CapRover。
