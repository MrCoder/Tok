#!/bin/bash

# DictaFlow.ai 自动更新发布脚本
# 用于构建、签名和发布新版本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
APP_NAME="DictaFlow"
BUNDLE_ID="ai.dictaflow.DictaFlow"
PRIVATE_KEY_FILE="sparkle_private_key.txt"
WEBSITE_DIR="website"
UPDATES_DIR="$WEBSITE_DIR/updates"
DOWNLOADS_DIR="$WEBSITE_DIR/downloads"

echo -e "${BLUE}🚀 DictaFlow.ai 更新发布脚本${NC}"
echo "=================================="

# 检查参数
if [ $# -lt 2 ]; then
    echo -e "${RED}❌ 用法: $0 <version> <build_number> [release_notes]${NC}"
    echo "例如: $0 1.0.0 1 '首个正式版本发布'"
    exit 1
fi

VERSION="$1"
BUILD_NUMBER="$2"
RELEASE_NOTES="${3:-新版本发布}"

echo -e "${BLUE}📦 版本信息:${NC}"
echo "版本号: $VERSION"
echo "构建号: $BUILD_NUMBER"
echo "发布说明: $RELEASE_NOTES"
echo

# 检查必要文件
if [ ! -f "$PRIVATE_KEY_FILE" ]; then
    echo -e "${RED}❌ 未找到私钥文件: $PRIVATE_KEY_FILE${NC}"
    echo "请先运行 ./generate_sparkle_keys.swift 生成密钥对"
    exit 1
fi

# 创建目录
mkdir -p "$DOWNLOADS_DIR"
mkdir -p "$UPDATES_DIR"

echo -e "${BLUE}🔨 构建应用...${NC}"

# 清理并构建
xcodebuild clean -scheme "$APP_NAME"
xcodebuild -scheme "$APP_NAME" -configuration Release archive -archivePath "./build/$APP_NAME.xcarchive"

# 导出应用
xcodebuild -exportArchive \
    -archivePath "./build/$APP_NAME.xcarchive" \
    -exportPath "./build/export" \
    -exportOptionsPlist exportOptions-developerid.plist

APP_PATH="./build/export/$APP_NAME.app"

if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}❌ 应用构建失败${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 应用构建成功${NC}"

# 创建DMG
DMG_NAME="$APP_NAME-$VERSION.dmg"
DMG_PATH="$DOWNLOADS_DIR/$DMG_NAME"

echo -e "${BLUE}📦 创建DMG: $DMG_NAME${NC}"

# 删除旧DMG
rm -f "$DMG_PATH"

# 创建临时目录
TEMP_DIR=$(mktemp -d)
cp -R "$APP_PATH" "$TEMP_DIR/"

# 创建DMG
hdiutil create -volname "$APP_NAME $VERSION" -srcfolder "$TEMP_DIR" -ov -format UDZO "$DMG_PATH"

# 清理临时目录
rm -rf "$TEMP_DIR"

# 获取文件大小
FILE_SIZE=$(stat -f%z "$DMG_PATH")

echo -e "${GREEN}✅ DMG创建成功: $DMG_PATH (${FILE_SIZE} bytes)${NC}"

# 签名DMG
echo -e "${BLUE}🔐 签名DMG...${NC}"

PRIVATE_KEY=$(cat "$PRIVATE_KEY_FILE")

# 使用Swift脚本签名（需要创建sign_update.swift）
./scripts/sign_update.swift "$DMG_PATH" "$PRIVATE_KEY" > signature.tmp
SIGNATURE=$(cat signature.tmp)
rm signature.tmp

echo -e "${GREEN}✅ DMG签名完成${NC}"

# 更新appcast.xml
echo -e "${BLUE}📝 更新appcast.xml...${NC}"

CURRENT_DATE=$(date -u +"%a, %d %b %Y %H:%M:%S +0000")
DOWNLOAD_URL="https://dictaflow.ai/downloads/$DMG_NAME"

# 备份现有appcast
cp "$UPDATES_DIR/appcast.xml" "$UPDATES_DIR/appcast.xml.backup"

# 创建新的item
cat > new_item.xml << EOF
    <item>
      <title>DictaFlow.ai $VERSION</title>
      <description><![CDATA[
        <h2>🎉 DictaFlow.ai $VERSION</h2>
        <p>$RELEASE_NOTES</p>
      ]]></description>
      <pubDate>$CURRENT_DATE</pubDate>
      <sparkle:version>$BUILD_NUMBER</sparkle:version>
      <sparkle:shortVersionString>$VERSION</sparkle:shortVersionString>
      <sparkle:minimumSystemVersion>15.0</sparkle:minimumSystemVersion>
      <sparkle:releaseNotesLink>https://dictaflow.ai/releases/$VERSION</sparkle:releaseNotesLink>
      <enclosure 
        url="$DOWNLOAD_URL" 
        length="$FILE_SIZE" 
        sparkle:edSignature="$SIGNATURE" 
        type="application/octet-stream"/>
    </item>
EOF

# 插入新item到appcast.xml
python3 -c "
import xml.etree.ElementTree as ET
import sys

# 读取现有appcast
tree = ET.parse('$UPDATES_DIR/appcast.xml')
root = tree.getroot()

# 读取新item
with open('new_item.xml', 'r') as f:
    new_item_xml = f.read()

# 找到channel
channel = root.find('channel')

# 解析新item并插入到第一个位置
new_item = ET.fromstring('<root>' + new_item_xml + '</root>')[0]

# 找到第一个已存在的item位置
first_item = channel.find('item')
if first_item is not None:
    # 在第一个item之前插入
    items = channel.findall('item')
    channel.remove(first_item)
    channel.append(new_item)
    channel.append(first_item)
else:
    # 如果没有item，直接添加
    channel.append(new_item)

# 保存
tree.write('$UPDATES_DIR/appcast.xml', encoding='utf-8', xml_declaration=True)
"

# 清理临时文件
rm new_item.xml

echo -e "${GREEN}✅ appcast.xml更新完成${NC}"

# 显示结果
echo
echo -e "${GREEN}🎉 发布完成!${NC}"
echo "=================================="
echo "版本: $VERSION (构建号: $BUILD_NUMBER)"
echo "DMG: $DMG_PATH"
echo "大小: $FILE_SIZE bytes"
echo "签名: $SIGNATURE"
echo "下载URL: $DOWNLOAD_URL"
echo
echo -e "${YELLOW}📋 下一步操作:${NC}"
echo "1. 测试DMG文件"
echo "2. 将website目录部署到服务器"
echo "3. 确认 https://dictaflow.ai/updates/appcast.xml 可访问"
echo "4. 在应用中测试自动更新功能"
