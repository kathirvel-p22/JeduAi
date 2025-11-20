# JeduAI Deployment Guide

## Overview

This guide covers deploying JeduAI to production environments including mobile app stores, web hosting, and backend infrastructure.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Supabase Setup](#supabase-setup)
3. [Android Deployment](#android-deployment)
4. [iOS Deployment](#ios-deployment)
5. [Web Deployment](#web-deployment)
6. [Environment Configuration](#environment-configuration)
7. [CI/CD Pipeline](#cicd-pipeline)
8. [Monitoring & Maintenance](#monitoring--maintenance)
9. [Security Checklist](#security-checklist)

---

## Prerequisites

### Required Tools

- Flutter SDK (>=3.0.0)
- Android Studio (for Android builds)
- Xcode (for iOS builds, Mac only)
- Node.js (for web deployment)
- Git
- Supabase CLI

### Required Accounts

- Supabase account
- Google Play Console (Android)
- Apple Developer Program (iOS)
- Web hosting provider (Netlify, Vercel, Firebase, etc.)

---

## Supabase Setup

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Click **New Project**
3. Enter project details:
   - Name: JeduAI Production
   - Database Password: (strong password)
   - Region: (closest to your users)
4. Wait for project creation (2-3 minutes)

### 2. Database Setup

**Run SQL Script:**

1. Open Supabase Dashboard
2. Go to **SQL Editor**
3. Copy contents from `database/setup.sql`
4. Click **Run**
5. Verify tables are created

**Alternative - Using Supabase CLI:**

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push
```

### 3. Configure Authentication

1. Go to **Authentication** > **Settings**
2. Enable email authentication
3. Configure email templates
4. Set up OAuth providers (optional):
   - Google
   - Apple
   - Microsoft

### 4. Storage Setup

1. Go to **Storage**
2. Create buckets:
   - `profile-images`
   - `class-recordings`
   - `assessment-files`
   - `translations`
3. Set bucket policies:

```sql
-- Public read for profile images
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'profile-images');

-- Authenticated users can upload
CREATE POLICY "Authenticated upload"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'profile-images' AND auth.role() = 'authenticated');
```

### 5. Get API Keys

1. Go to **Settings** > **API**
2. Copy:
   - Project URL
   - Anon/Public Key
   - Service Role Key (keep secret!)

### 6. Configure Row Level Security

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE online_classes ENABLE ROW LEVEL SECURITY;
-- ... (repeat for all tables)

-- Create policies
CREATE POLICY "Users can read own data"
ON users FOR SELECT
USING (auth.uid()::text = id);

CREATE POLICY "Staff can create classes"
ON online_classes FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM users
    WHERE id = auth.uid()::text
    AND role = 'staff'
  )
);
```

---

## Android Deployment

### 1. Prepare for Release

**Update App Configuration:**

```yaml
# pubspec.yaml
name: jeduai_app
description: Advanced Educational Platform
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
```

**Configure Android:**

```gradle
// android/app/build.gradle
android {
    defaultConfig {
        applicationId "com.jeduai.app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 2. Generate Signing Key

```bash
# Generate keystore
keytool -genkey -v -keystore jeduai-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias jeduai

# Create key.properties
echo "storePassword=your-store-password" > android/key.properties
echo "keyPassword=your-key-password" >> android/key.properties
echo "keyAlias=jeduai" >> android/key.properties
echo "storeFile=../jeduai-release-key.jks" >> android/key.properties
```

### 3. Build Release APK/AAB

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Output locations:
# APK: build/app/outputs/flutter-apk/app-release.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

### 4. Google Play Console Setup

1. **Create App:**
   - Go to [Google Play Console](https://play.google.com/console)
   - Click **Create App**
   - Fill in app details

2. **App Content:**
   - Privacy Policy URL
   - App category
   - Content rating questionnaire
   - Target audience

3. **Store Listing:**
   - App name: JeduAI
   - Short description (80 chars)
   - Full description (4000 chars)
   - Screenshots (phone, tablet)
   - Feature graphic (1024x500)
   - App icon (512x512)

4. **Release:**
   - Upload AAB file
   - Release notes
   - Submit for review

### 5. Testing

```bash
# Install release APK on device
adb install build/app/outputs/flutter-apk/app-release.apk

# Test thoroughly:
# - All features work
# - No debug logs
# - Performance is good
# - No crashes
```

---

## iOS Deployment

### 1. Prepare for Release

**Configure iOS:**

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>JeduAI</string>
<key>CFBundleIdentifier</key>
<string>com.jeduai.app</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<!-- Camera permission -->
<key>NSCameraUsageDescription</key>
<string>JeduAI needs camera access for video classes</string>

<!-- Microphone permission -->
<key>NSMicrophoneUsageDescription</key>
<string>JeduAI needs microphone access for video classes</string>
```

### 2. Xcode Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** project
3. **General** tab:
   - Display Name: JeduAI
   - Bundle Identifier: com.jeduai.app
   - Version: 1.0.0
   - Build: 1
4. **Signing & Capabilities**:
   - Team: (your Apple Developer team)
   - Automatically manage signing: ✓

### 3. Build for Release

```bash
# Build iOS release
flutter build ios --release

# Or build IPA
flutter build ipa --release
```

### 4. Archive in Xcode

1. Open Xcode
2. Select **Any iOS Device** as target
3. **Product** > **Archive**
4. Wait for archive to complete
5. **Window** > **Organizer**
6. Select your archive
7. Click **Distribute App**
8. Choose **App Store Connect**
9. Follow the wizard

### 5. App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. **My Apps** > **+** > **New App**
3. Fill in app information:
   - Platform: iOS
   - Name: JeduAI
   - Primary Language: English
   - Bundle ID: com.jeduai.app
   - SKU: JEDUAI001

4. **App Information:**
   - Privacy Policy URL
   - Category: Education
   - Content Rights

5. **Pricing and Availability:**
   - Price: Free or Paid
   - Availability: All countries

6. **Prepare for Submission:**
   - Screenshots (6.5", 5.5", iPad Pro)
   - App Preview videos (optional)
   - Description
   - Keywords
   - Support URL
   - Marketing URL

7. **Submit for Review**

---

## Web Deployment

### 1. Build Web Version

```bash
# Build for web
flutter build web --release

# Output: build/web/
```

### 2. Configure Web

**Update index.html:**

```html
<!-- build/web/index.html -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JeduAI - Advanced Educational Platform</title>
  <meta name="description" content="AI-powered educational platform with video classes, assessments, and translation">
  
  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>
  
  <!-- PWA -->
  <link rel="manifest" href="manifest.json">
  <meta name="theme-color" content="#4CAF50">
</head>
<body>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

### 3. Deploy to Netlify

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Deploy
cd build/web
netlify deploy --prod

# Or use drag-and-drop on netlify.com
```

**netlify.toml:**

```toml
[build]
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### 4. Deploy to Vercel

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd build/web
vercel --prod
```

**vercel.json:**

```json
{
  "routes": [
    { "handle": "filesystem" },
    { "src": "/.*", "dest": "/index.html" }
  ]
}
```

### 5. Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy --only hosting
```

**firebase.json:**

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

---

## Environment Configuration

### 1. Environment Files

**Create environment files:**

```dart
// lib/config/environment.dart
class Environment {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );
  
  static const bool isProduction = bool.fromEnvironment(
    'PRODUCTION',
    defaultValue: false,
  );
}
```

### 2. Build with Environment

```bash
# Production build
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://prod.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=prod-key \
  --dart-define=PRODUCTION=true

# Staging build
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://staging.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=staging-key \
  --dart-define=PRODUCTION=false
```

---

## CI/CD Pipeline

### GitHub Actions

**Create `.github/workflows/deploy.yml`:**

```yaml
name: Deploy JeduAI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build iOS
        run: flutter build ios --release --no-codesign

  build-web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build Web
        run: flutter build web --release
      
      - name: Deploy to Netlify
        uses: netlify/actions/cli@master
        with:
          args: deploy --prod --dir=build/web
        env:
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
```

---

## Monitoring & Maintenance

### 1. Error Tracking

**Sentry Integration:**

```dart
// lib/main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'your-sentry-dsn';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}
```

### 2. Analytics

**Firebase Analytics:**

```dart
// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
```

### 3. Performance Monitoring

**Supabase Dashboard:**
- Monitor database queries
- Check API response times
- Track storage usage
- Review error logs

### 4. Backup Strategy

```bash
# Automated daily backups
# Supabase provides automatic backups

# Manual backup
supabase db dump > backup-$(date +%Y%m%d).sql

# Restore from backup
supabase db reset
psql -h db.your-project.supabase.co -U postgres -d postgres < backup.sql
```

---

## Security Checklist

### Pre-Deployment

- [ ] Remove all debug logs
- [ ] Secure API keys (use environment variables)
- [ ] Enable Row Level Security on all tables
- [ ] Configure CORS properly
- [ ] Enable HTTPS only
- [ ] Implement rate limiting
- [ ] Add input validation
- [ ] Sanitize user inputs
- [ ] Enable authentication
- [ ] Set up proper permissions
- [ ] Review privacy policy
- [ ] Implement data encryption
- [ ] Configure backup strategy
- [ ] Set up monitoring
- [ ] Test security vulnerabilities

### Post-Deployment

- [ ] Monitor error logs
- [ ] Check performance metrics
- [ ] Review user feedback
- [ ] Update dependencies regularly
- [ ] Perform security audits
- [ ] Test disaster recovery
- [ ] Monitor database performance
- [ ] Review access logs

---

## Troubleshooting

### Common Issues

**Build Failures:**
```bash
# Clean build
flutter clean
flutter pub get
flutter build apk --release
```

**Signing Issues (Android):**
- Verify keystore path
- Check key.properties file
- Ensure passwords are correct

**iOS Code Signing:**
- Check Apple Developer account
- Verify provisioning profiles
- Update certificates if expired

**Web Deployment:**
- Check base href in index.html
- Verify routing configuration
- Test on different browsers

---

## Support

For deployment issues:
- Email: devops@jeduai.com
- Documentation: docs.jeduai.com
- GitHub Issues: github.com/jeduai/app/issues

---

**Last Updated**: December 2024
