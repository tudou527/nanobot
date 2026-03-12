# CapRover 启动命令配置

## 问题说明

官方 Dockerfile 的默认命令是：
```dockerfile
ENTRYPOINT ["nanobot"]
CMD ["status"]
```

这只会显示状态信息，不会启动 Gateway 服务。

## 解决方案

✅ **本仓库已通过自定义 Dockerfile 解决此问题**

我们的 `Dockerfile` 会：
1. 基于构建好的 nanobot 镜像
2. 覆盖默认的 `CMD` 为 `["gateway"]`

```dockerfile
# 从已构建的镜像创建
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# 覆盖默认命令，启动 Gateway 服务
CMD ["gateway"]
```

## GitHub Actions 工作流

工作流分两步构建：
1. **构建基础镜像**：使用官方 Dockerfile 构建 nanobot
2. **构建最终镜像**：使用我们的 Dockerfile 包装，覆盖启动命令

这样部署到 CapRover 后会自动启动 Gateway 服务，无需手动配置。

## 验证

部署后检查日志应该看到：
```
🐈 nanobot Gateway
Starting server on 0.0.0.0:18790
```

而不是只显示 status 信息。
