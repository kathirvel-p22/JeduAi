# Firebase Setup Guide for JeduAI

This guide will help you set up Firebase for real-time authentication and database functionality in JeduAI.

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: `jeduai-app` (or your preferred name)
4. Disable Google Analytics (optional)
5. Click "Create project"

## Step 2: Register Your App

### For Web:
1. In Firebase Console, click the **Web icon** (</>)
2. Register app with nickname: `JeduAI Web`
3. Check "Also set up Firebase Hosting" (optional)
4. Click "Register app"
5. Copy the Firebase configuration

### For Android:
1. Click the **Android icon**
2. Enter package name: `com.example.jeduai_app1`
3. Download `google-services.json`
4. Place it in `android/app/` directory

### For iOS:
1. Click the **iOS icon**
2. Enter bundle ID: `com.example.jeduaiApp1`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

## Step 3: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get started"
3. Go to **Sign-in method** tab
4. Enable **Email/Password** provider
5. Click "Save"

## Step 4: Set Up Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
4. Select a location (closest to your users)
5. Click "Enable"

### Firestore Security Rules (for production):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow admins to read/write everything
    match /{document=**} {
      allow read, write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## Step 5: Update Firebase Configuration

### Option A: Using FlutterFire CLI (Recommended)

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Run FlutterFire configure:
```bash
flutterfire configure
```

3. Select your Firebase project
4. Select platforms (Web, Android, iOS, etc.)
5. This will automatically update `lib/firebase_options.dart`

### Option B: Manual Configuration

Update `lib/firebase_options.dart` with your Firebase config:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',
  appId: 'YOUR_WEB_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  measurementId: 'YOUR_MEASUREMENT_ID',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

## Step 6: Initialize Firebase in Your App

The app already initializes Firebase in `main.dart`. Make sure it looks like this:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}
```

## Step 7: Test Authentication

1. Run the app:
```bash
flutter run -d chrome
```

2. Click "Sign Up" on the login screen
3. Fill in the registration form:
   - Full Name: Test User
   - Email: test@example.com
   - Role: Student
   - Password: test123
   - Confirm Password: test123

4. Click "Sign Up"
5. Check Firebase Console → Authentication → Users to see the new user

## Step 8: Verify Firestore Data

1. Go to Firebase Console → Firestore Database
2. You should see a `users` collection
3. Click on it to see user documents with fields:
   - uid
   - name
   - email
   - role
   - createdAt
   - updatedAt

## Troubleshooting

### Error: "Firebase not initialized"
- Make sure `Firebase.initializeApp()` is called in `main.dart`
- Check that `firebase_options.dart` has valid configuration

### Error: "Email already in use"
- The email is already registered
- Try a different email or delete the user from Firebase Console

### Error: "Weak password"
- Password must be at least 6 characters
- Use a stronger password

### Error: "Invalid email"
- Check email format (must contain @)
- Remove any spaces

### Error: "Network request failed"
- Check internet connection
- Verify Firebase project is active
- Check API keys are correct

## Production Deployment

Before deploying to production:

1. **Update Firestore Security Rules** (see Step 4)
2. **Enable App Check** for additional security
3. **Set up Firebase Storage** for file uploads
4. **Configure Firebase Hosting** for web deployment
5. **Enable Firebase Analytics** for user insights

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

## Support

If you encounter issues:
1. Check Firebase Console for error logs
2. Review Flutter console output
3. Verify all configuration steps
4. Check Firebase status page

---

**Note**: The current app uses dummy Firebase credentials. You MUST set up your own Firebase project for the app to work with real authentication.
