# 🚀 DictaFlow.ai 自动更新部署指南

## 概述

本指南将帮你设置DictaFlow.ai的完整自动更新系统，包括构建、签名、发布和部署。

## 🔧 系统组件

### 1. **Sparkle框架**
- **功能**: 处理自动更新逻辑
- **配置**: Info.plist中的SUFeedURL和SUPublicEDKey
- **UI**: 集成在AboutView和SettingsView中

### 2. **EdDSA签名系统**
- **公钥**: 存储在Info.plist中，用于验证更新包
- **私钥**: 安全保存，用于签名发布包
- **算法**: Ed25519 (Curve25519.Signing)

### 3. **Appcast.xml**
- **位置**: `https://dictaflow.ai/updates/appcast.xml`
- **格式**: RSS 2.0 with Sparkle extensions
- **内容**: 版本信息、下载链接、发布说明

## 📋 部署步骤

### 第1步：密钥管理

1. **生成密钥对** (已完成):
   ```bash
   ./generate_sparkle_keys.swift
   ```

2. **安全存储私钥**:
   ```bash
   # 将私钥存储在安全位置
   cp sparkle_private_key.txt ~/.ssh/dictaflow_sparkle_private_key
   chmod 600 ~/.ssh/dictaflow_sparkle_private_key
   ```

3. **删除工作目录中的私钥**:
   ```bash
   rm sparkle_private_key.txt sparkle_public_key.txt
   ```

### 第2步：网站部署

1. **部署appcast.xml**:
   ```bash
   # 将website/updates/目录部署到你的服务器
   # 确保 https://dictaflow.ai/updates/appcast.xml 可访问
   ```

2. **创建downloads目录**:
   ```bash
   # 确保 https://dictaflow.ai/downloads/ 目录存在且可写
   ```

### 第3步：发布新版本

1. **使用发布脚本**:
   ```bash
   # 语法: ./scripts/release-update.sh <version> <build_number> [release_notes]
   ./scripts/release-update.sh 1.0.0 1 "首个正式版本发布"
   ```

2. **脚本执行流程**:
   - 清理并构建应用
   - 导出签名的.app文件
   - 创建DMG包
   - 使用私钥签名DMG
   - 更新appcast.xml
   - 生成部署文件

### 第4步：测试更新流程

1. **手动检查**:
   - 在应用中点击"Check for Updates"
   - 验证是否检测到新版本

2. **自动更新测试**:
   - 等待自动检查周期
   - 或重启应用触发检查

## 🔐 安全最佳实践

### 密钥安全
- ✅ 私钥存储在安全位置 (`~/.ssh/`)
- ✅ 私钥文件权限设为600
- ❌ 不要将私钥提交到Git
- ❌ 不要在脚本中硬编码私钥

### 更新验证
- ✅ 所有更新包都使用EdDSA签名
- ✅ 客户端验证签名后才安装
- ✅ 使用HTTPS传输更新包
- ✅ 最小系统版本检查

## 📁 文件结构

```
DictaFlow.ai/
├── Hex/
│   ├── Info.plist (SUFeedURL, SUPublicEDKey)
│   └── App/CheckForUpdatesView.swift
├── scripts/
│   ├── release-update.sh (发布脚本)
│   └── sign_update.swift (签名工具)
├── website/
│   ├── updates/appcast.xml (更新源)
│   └── downloads/ (DMG文件)
└── exportOptions-*.plist (构建配置)
```

## 🌐 网站配置

### Apache .htaccess
```apache
# 确保appcast.xml正确的MIME类型
<Files "appcast.xml">
    ForceType application/rss+xml
</Files>

# 启用压缩
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE application/rss+xml
</IfModule>
```

### Nginx配置
```nginx
location /updates/appcast.xml {
    add_header Content-Type application/rss+xml;
    gzip on;
}

location /downloads/ {
    add_header Content-Disposition attachment;
}
```

## 🔄 自动化CI/CD (可选)

### GitHub Actions示例
```yaml
name: Release DictaFlow
on:
  push:
    tags: ['v*']

jobs:
  release:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and Release
        env:
          SPARKLE_PRIVATE_KEY: ${{ secrets.SPARKLE_PRIVATE_KEY }}
        run: |
          echo "$SPARKLE_PRIVATE_KEY" > sparkle_private_key.txt
          ./scripts/release-update.sh ${GITHUB_REF#refs/tags/v} ${{ github.run_number }}
```

## 🐛 故障排除

### 常见问题

1. **更新检查失败**:
   - 检查appcast.xml是否可访问
   - 验证XML格式是否正确
   - 确认网络连接

2. **签名验证失败**:
   - 确认公钥在Info.plist中正确
   - 检查私钥是否正确
   - 验证签名算法匹配

3. **下载失败**:
   - 检查DMG文件是否存在
   - 验证下载URL是否正确
   - 确认文件权限

### 调试命令

```bash
# 验证appcast.xml
curl -s https://dictaflow.ai/updates/appcast.xml | head -20

# 检查DMG签名
./scripts/sign_update.swift path/to/file.dmg $(cat ~/.ssh/dictaflow_sparkle_private_key)

# 验证XML格式
xmllint --noout website/updates/appcast.xml
```

## 📞 支持

如果遇到问题，请检查:
1. [Sparkle文档](https://sparkle-project.org/documentation/)
2. [项目Issue](https://github.com/untsop/Hex/issues)
3. 本地日志文件
