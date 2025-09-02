# DictaFlow Installation Guide

## ✅ Properly Signed App

DictaFlow is now properly signed with a Developer ID certificate! This means you should **no longer see security warnings** when installing and running the app.

## Installation Steps

1. **Download**: Click the download button to get `DictaFlow-v1.0.0.dmg`
2. **Open DMG**: Double-click the downloaded DMG file
3. **Install**: Drag DictaFlow.app to the Applications folder
4. **Launch**: Open DictaFlow from your Applications folder

## If You Still See a Security Warning

If you encounter any security warnings (which should be rare now), here's how to resolve them:

### Method 1: Right-Click to Open (Recommended)

1. **Right-click** on `DictaFlow.app` in your Applications folder
2. Select **"Open"** from the menu
3. Click **"Open"** in the security dialog that appears
4. DictaFlow will launch and be trusted for all future uses

### Method 2: System Settings

1. Try to open DictaFlow normally (it will be blocked)
2. Open **System Settings** → **Privacy & Security**
3. Scroll down to find **"DictaFlow was blocked from use..."**
4. Click **"Open Anyway"**
5. Try opening DictaFlow again

### Method 3: Terminal (Advanced)

```bash
sudo xattr -rd com.apple.quarantine /Applications/DictaFlow.app
```

## Why This Happens

DictaFlow is currently signed with a development certificate rather than a distribution certificate. This is common for open-source software distributed outside the Mac App Store.

## Is It Safe?

Yes! DictaFlow is completely safe:
- ✅ Open source code available on GitHub
- ✅ No network connections for transcription (everything runs locally)
- ✅ No data collection or telemetry
- ✅ Transparent development process

## Need Help?

If you have any issues with installation, please:
- Check our [GitHub Issues](https://github.com/dictaflow/dictaflow/issues)
- Contact support at support@dictaflow.ai

---

**Note**: We're working on proper code signing and notarization to eliminate these security warnings in future releases.
