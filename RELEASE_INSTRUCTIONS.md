# 📦 JeduAI Release Instructions

## Creating a GitHub Release with APK

Since the APK file is large (160MB), it's better to upload it as a GitHub Release rather than committing it to the repository.

### Steps to Create a Release:

1. **Go to GitHub Repository**
   - Navigate to: https://github.com/kathirvel-p22/JeduAi

2. **Create New Release**
   - Click on "Releases" (right sidebar)
   - Click "Create a new release"

3. **Release Details**
   - **Tag version**: `v1.0.0`
   - **Release title**: `JeduAI v1.0.0 - AI-Powered Education Platform`
   - **Description**:
   ```markdown
   ## 🎓 JeduAI v1.0.0
   
   First official release of JeduAI - Smart Learning & Assessment Platform
   
   ### ✨ Features
   - 🤖 AI Assessment Generator with Gemini 2.5 Flash
   - 💬 AI Tutor with multi-language support
   - 🌐 100+ language translation for all portals
   - 🎥 Video/Audio translation (20+ languages)
   - 👨‍🎓 Student Portal with progress tracking
   - 👨‍🏫 Staff Portal with assessment tools
   - 👨‍💼 Admin Portal with full oversight
   
   ### 🎥 Video Translation
   - Upload any video and translate to 20+ languages
   - Three modes: Basic, Advanced AI (Gemini), Full Pipeline
   - Automatic subtitle generation
   - Voice-over with Text-to-Speech
   
   ### 🌐 Supported Languages
   English, Hindi, Tamil, Telugu, Kannada, Malayalam, Bengali, Marathi, Gujarati, Punjabi, Urdu, Spanish, French, German, Chinese, Japanese, Korean, Arabic, Portuguese, Russian, and more!
   
   ### 📥 Installation
   1. Download the APK file below
   2. Enable "Install from Unknown Sources" in Android settings
   3. Install and launch JeduAI
   
   ### 🔑 Demo Credentials
   - **Student**: kathirvel@gmail.com (any password)
   - **Staff**: vijayakumar@vsb.edu (any password)
   - **Admin**: admin@vsb.edu (any password)
   ```

4. **Upload APK**
   - Drag and drop or click "Attach binaries"
   - Upload: `jeduai_app1/jeduai-app-v1.0.0-debug.apk`
   - Rename to: `jeduai-app-v1.0.0.apk`

5. **Publish Release**
   - Check "Set as the latest release"
   - Click "Publish release"

## APK Location

The APK file is located at:
```
jeduai_app1/jeduai-app-v1.0.0-debug.apk
```

Size: ~160 MB

## Building Release APK

To build a release APK (smaller size, optimized):

```bash
cd jeduai_app1
flutter build apk --release
```

The release APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Alternative: Build App Bundle for Play Store

For Google Play Store submission:

```bash
flutter build appbundle --release
```

The bundle will be at:
```
build/app/outputs/bundle/release/app-release.aab
```

## After Creating Release

Update the README.md download link to point to the release:

```markdown
**[📱 Download JeduAI APK (v1.0.0)](https://github.com/kathirvel-p22/JeduAi/releases/download/v1.0.0/jeduai-app-v1.0.0.apk)**
```

## Notes

- Debug APK is larger (~160MB) but easier to test
- Release APK is smaller (~50-80MB) and optimized
- App Bundle (.aab) is required for Play Store
- Always test the APK before releasing

---

**Made with ❤️ for VSB Engineering College**
