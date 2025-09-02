# DictaFlow Installation Guide

## macOS Security Warning

When you first open DictaFlow, you may see a security warning: *"Apple could not verify DictaFlow is free of malware..."*

This is normal for apps distributed outside the Mac App Store. Here's how to safely install DictaFlow:

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
