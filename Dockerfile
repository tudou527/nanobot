# 从已构建的镜像创建
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# 覆盖默认命令，启动 Gateway 服务
CMD ["gateway"]
