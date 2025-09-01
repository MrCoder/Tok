#!/bin/bash

# Local DMG creation script for DictaFlow
set -e

echo "🏗️  Creating local DMG for DictaFlow..."

# Define paths
BUILD_DIR="/Users/pengxiao/Library/Developer/Xcode/DerivedData/Hex-acgxzcmijhjjlpgvedpzyatwpvla/Build/Products/Debug"
APP_PATH="$BUILD_DIR/DictaFlow.app"
DMG_NAME="DictaFlow-local-$(date +%Y%m%d-%H%M%S).dmg"

# Check if the app exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ App not found at: $APP_PATH"
    echo "💡 Please build the app first with:"
    echo "   xcodebuild -project Hex.xcodeproj -scheme DictaFlow -configuration Debug clean build"
    exit 1
fi

echo "✅ Found DictaFlow.app at: $APP_PATH"

# Create a temporary directory for the DMG contents
TEMP_DIR=$(mktemp -d)
echo "📁 Using temp directory: $TEMP_DIR"

# Copy the app to temp directory
cp -R "$APP_PATH" "$TEMP_DIR/"

# Create the DMG
echo "📦 Creating DMG..."
create-dmg \
  --volname "DictaFlow" \
  --volicon "./Hex/Assets.xcassets/AppIcon.appiconset/iTunesArtwork@2x.png" \
  --window-pos 200 120 \
  --window-size 600 300 \
  --icon-size 100 \
  --icon "DictaFlow.app" 175 120 \
  --hide-extension "DictaFlow.app" \
  --app-drop-link 425 120 \
  "$DMG_NAME" \
  "$TEMP_DIR"

# Clean up
rm -rf "$TEMP_DIR"

echo "✅ DMG created successfully: $DMG_NAME"
echo "📂 You can find it in the current directory"
echo "🚀 Test it by double-clicking to mount and then dragging DictaFlow.app to Applications"

