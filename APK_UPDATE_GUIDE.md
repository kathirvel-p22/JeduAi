# APK Update Guide - How to Update Your App

## Understanding APK Updates

### ❌ APKs DO NOT Auto-Update
- APK files are static snapshots of your code
- When you make code changes, the old APK doesn't change
- Users must download and install a new APK manually

### ✅ How Updates Work

**Without Auto-Update System:**
1. You make code changes
2. Build new APK
3. Upload to Google Drive
4. Share new link with users
5. Users manually download and install

**With Auto-Update System (Implemented):**
1. You make code changes
2. Build new APK
3. Upload to Google Drive
4. Update version.json file
5. Push to GitHub
6. App automatically detects update
7. Shows "Update Available" dialog
8. User clicks "Update Now"
9. Opens download link
10. User installs new APK

---

## Step-by-Step: How to Release an Update

### Step 1: Update Version Number

Edit `pubspec.yaml`:
```yaml
version: 1.0.1+2  # Change from 1.0.0+1
```

Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`
- 1.0.0 → 1.0.1 (bug fixes)
- 1.0.0 → 1.1.0 (new features)
- 1.0.0 → 2.0.0 (major changes)

### Step 2: Build New APK

```bash
cd jeduai_app1
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

### Step 3: Upload to Google Drive

1. Go to Google Drive
2. Upload the new APK
3. Right-click → Get link → Copy link
4. Make sure link sharing is set to "Anyone with the link"

Example link:
```
https://drive.google.com/file/d/YOUR_FILE_ID/view?usp=sharing
```

### Step 4: Update version.json

Edit `jeduai_app1/version.json`:
```json
{
  "version": "1.0.1",
  "downloadUrl": "YOUR_NEW_GOOGLE_DRIVE_LINK",
  "message": "What's new in this version",
  "releaseDate": "2024-02-20",
  "mandatory": false,
  "minSupportedVersion": "1.0.0"
}
```

### Step 5: Push to GitHub

```bash
git add .
git commit -m "Release v1.0.1 - Added new features"
git push origin main
```

### Step 6: Update README

Edit the download link in README.md:
```markdown
[Download JeduAI App (v1.0.1)](YOUR_NEW_GOOGLE_DRIVE_LINK)
```

### Step 7: Test the Update

1. Install the OLD APK on a test device
2. Open the app
3. You should see "Update Available" dialog
4. Click "Update Now"
5. Download and install new APK

---

## Auto-Update System Setup

### 1. Add Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  package_info_plus: ^8.0.0
  url_launcher: ^6.3.0
  http: ^1.2.0
```

Run:
```bash
flutter pub get
```

### 2. Initialize in main.dart

```dart
import 'services/app_update_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Get package info
  final packageInfo = await PackageInfo.fromPlatform();
  Get.put(packageInfo, permanent: true);
  
  // Initialize update service
  final updateService = Get.put(AppUpdateService(), permanent: true);
  
  runApp(const MyApp());
  
  // Check for updates after app starts
  Future.delayed(Duration(seconds: 2), () {
    updateService.checkForUpdates();
  });
}
```

### 3. Add Manual Check Button

In settings or profile view:
```dart
ElevatedButton.icon(
  onPressed: () {
    Get.find<AppUpdateService>().manualUpdateCheck();
  },
  icon: Icon(Icons.system_update),
  label: Text('Check for Updates'),
)
```

---

## version.json Configuration

### Location Options

**Option 1: GitHub (Recommended)**
```
https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/version.json
```

**Option 2: Your Own Server**
```
https://yourwebsite.com/jeduai/version.json
```

**Option 3: Firebase Hosting**
```
https://your-project.web.app/version.json
```

### Update the URL

In `app_update_service.dart`, change:
```dart
static const String versionCheckUrl = 
    'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/version.json';
```

### version.json Fields

```json
{
  "version": "1.0.1",              // Latest version number
  "downloadUrl": "...",            // Google Drive link to APK
  "message": "What's new",         // Update message to show user
  "releaseDate": "2024-02-20",     // Release date
  "mandatory": false,              // If true, force update
  "minSupportedVersion": "1.0.0"   // Minimum version that still works
}
```

---

## Quick Update Checklist

When you want to release an update:

- [ ] Make your code changes
- [ ] Test thoroughly
- [ ] Update version in `pubspec.yaml` (e.g., 1.0.0 → 1.0.1)
- [ ] Build APK: `flutter build apk --release`
- [ ] Upload APK to Google Drive
- [ ] Copy the share link
- [ ] Update `version.json` with new version and link
- [ ] Update README.md with new download link
- [ ] Commit and push to GitHub
- [ ] Test update on a device with old version

---

## For Users: How to Install Updates

### Method 1: In-App Update (Automatic)
1. Open the app
2. If update available, you'll see a dialog
3. Click "Update Now"
4. Browser opens with download link
5. Download the APK
6. Click the downloaded file
7. Click "Install"
8. Done!

### Method 2: Manual Update
1. Go to GitHub README
2. Click the download link
3. Download new APK
4. Install over old version
5. Your data is preserved!

---

## Important Notes

### ✅ Data Preservation
- Installing new APK over old one preserves all data
- User accounts, settings, and progress are kept
- No need to login again

### ⚠️ Uninstall = Data Loss
- If user uninstalls app, all local data is lost
- To prevent this, implement cloud backup (Firebase/Supabase)

### 🔒 Android Security
- Users need to enable "Install from Unknown Sources"
- This is normal for APK files not from Play Store

### 📱 Play Store Alternative
- If you publish to Google Play Store, updates are automatic
- Users get updates through Play Store
- No manual APK distribution needed

---

## Troubleshooting

**Q: Update dialog doesn't show**
- Check internet connection
- Verify version.json URL is correct
- Check version.json is accessible (open URL in browser)
- Ensure version number in version.json is higher than current

**Q: Download link doesn't work**
- Make sure Google Drive link sharing is enabled
- Use direct download link format (see below)

**Q: Can't install new APK**
- Enable "Install from Unknown Sources" in Android settings
- Make sure you're installing over the same package name

**Q: Data lost after update**
- This shouldn't happen if installing over old version
- If it does, implement cloud backup

---

## Google Drive Direct Download Link

Regular link:
```
https://drive.google.com/file/d/FILE_ID/view?usp=sharing
```

Direct download link (better for auto-update):
```
https://drive.google.com/uc?export=download&id=FILE_ID
```

Extract FILE_ID from your link and use the direct download format.

---

## Future Improvements

### Option 1: In-App Download
- Download APK directly in app
- Show progress bar
- Auto-install when done
- Requires additional permissions

### Option 2: Play Store
- Publish to Google Play Store
- Automatic updates for all users
- No manual APK distribution
- Requires $25 one-time fee

### Option 3: Firebase App Distribution
- Free alternative to Play Store
- Testers get automatic updates
- Good for beta testing
- Requires Firebase setup

---

## Summary

**Current Setup:**
- ✅ Auto-update checker implemented
- ✅ Shows "Update Available" dialog
- ✅ Opens download link in browser
- ✅ User manually installs APK

**Your Workflow:**
1. Make changes
2. Build APK
3. Upload to Drive
4. Update version.json
5. Push to GitHub
6. Users get notified automatically!

**User Experience:**
1. Open app
2. See "Update Available"
3. Click "Update Now"
4. Download and install
5. Enjoy new features!
