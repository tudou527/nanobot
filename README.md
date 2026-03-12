# Nanobot CapRover 部署

这是一个用于将 [nanobot](https://github.com/nanbingxyz/nanobot) 自动部署到 CapRover 的独立仓库。

## 方案特点

✅ **独立维护**：不需要 fork nanobot 仓库，避免上游同步冲突
✅ **自动化部署**：通过 GitHub Actions 一键构建和部署
✅ **版本控制**：可以锁定特定版本或跟踪最新版本
✅ **配置隔离**：部署配置与源码分离，更清晰
✅ **持久化数据**：配置和数据不会因更新丢失

## 前置要求

- GitHub 账号（用于运行 GitHub Actions）
- CapRover 服务器（已安装并配置）
- CapRover 中已创建应用（如 `nanobot`）

## 快速开始

### 1. 配置 GitHub Secrets

在你的 GitHub 仓库中，进入 `Settings` → `Secrets and variables` → `Actions`，添加以下 secrets：

| Secret 名称 | 说明 | 示例 |
|------------|------|------|
| `CAPROVER_SERVER` | CapRover 服务器地址 | `https://captain.your-domain.com` |
| `APP_NAME` | CapRover 应用名称 | `nanobot` |
| `APP_TOKEN` | CapRover 应用 Token | `eyJhbGc...` |

**注意**：`GITHUB_TOKEN` 由 GitHub Actions 自动提供，无需手动配置。

### 2. 在 CapRover 中创建应用

1. 登录 CapRover 管理面板
2. 创建新应用，命名为 `nanobot`
3. 配置持久化目录：
   - 路径：`/root/.nanobot`
   - 标签：`nanobot-data`
4. 配置端口映射：
   - 容器端口：`18790`
   - 启用 HTTP 和 HTTPS

### 3. 触发部署

1. 进入 GitHub 仓库的 `Actions` 标签页
2. 选择 `Deploy to CapRover` 工作流
3. 点击 `Run workflow`
4. 选择 nanobot 版本（默认为 `main`）
5. 点击 `Run workflow` 开始部署

## 部署流程说明

GitHub Actions 工作流会自动执行以下步骤：

1. **Clone nanobot 仓库**：从官方仓库拉取指定版本的代码
2. **构建 nanobot 基础镜像**：使用官方 Dockerfile 构建基础镜像
3. **构建最终镜像**：使用我们的 Dockerfile 包装基础镜像，覆盖启动命令为 `gateway`
4. **推送到 GitHub Container Registry**：将最终镜像推送到 ghcr.io
5. **触发 CapRover 部署**：使用 caprover/deploy-from-github action 自动部署

**注意**：我们的 Dockerfile 会自动将启动命令从 `status` 改为 `gateway`，确保 Gateway 服务正常启动。

## 首次部署后的配置

部署完成后，需要初始化 nanobot 配置：

### 方式 1：通过 CapRover Console

1. 在 CapRover 中进入 `nanobot` 应用
2. 点击 `App Configs` → `Deployment` → `Execute Command`
3. 执行命令：
   ```bash
   nanobot onboard
   ```
4. 按照提示配置 LLM API keys 等信息

### 方式 2：手动上传配置文件

1. 准备好 `config.json` 文件
2. 在 CapRover 中进入 `nanobot` 应用
3. 使用 File Manager 或 SSH 将配置文件上传到 `/root/.nanobot/config.json`

## 配置文件结构

nanobot 的配置目录结构：

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

## 更新部署

当 nanobot 官方仓库有新版本时：

1. 进入 GitHub Actions
2. 运行 `Deploy to CapRover` 工作流
3. 指定新版本号（如 `v0.1.5`）或使用 `main` 获取最新代码
4. CapRover 会自动拉取新镜像并重启应用

**注意**：配置文件和数据会保留，不会丢失。

## 版本管理

### 使用特定版本

在触发工作流时，输入具体的 tag：
```
v0.1.4
```

### 使用最新代码

使用默认值或输入：
```
main
```

### 使用特定分支

输入分支名称：
```
develop
```

## 环境变量配置

如果需要通过环境变量配置 nanobot，可以在 CapRover 的 `App Configs` → `Environment Variables` 中添加：

```
OPENAI_API_KEY=sk-xxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxx
```

## 故障排查

### 部署失败

1. 检查 GitHub Actions 日志，查看具体错误信息
2. 确认 GitHub Secrets 配置正确
3. 确认 CapRover 服务器可访问

### 应用无法启动

1. 在 CapRover 中查看应用日志
2. 检查配置文件是否正确
3. 确认持久化目录已正确挂载

### 无法访问服务

1. 检查 CapRover 端口映射配置
2. 确认防火墙规则
3. 检查 nanobot gateway 服务是否正常运行

## 验证部署

部署完成后，可以通过以下方式验证：

### 检查健康状态

```bash
curl https://nanobot.your-domain.com/health
```

### 查看应用状态

在 CapRover Console 中执行：
```bash
nanobot status
```

### 测试聊天功能

配置 Telegram/Discord 等平台后，发送测试消息验证功能。

## 相关链接

- [Nanobot 官方仓库](https://github.com/nanbingxyz/nanobot)
- [CapRover 文档](https://caprover.com/docs/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## 许可证

本部署配置遵循 MIT 许可证。Nanobot 项目遵循其自身的许可证。
