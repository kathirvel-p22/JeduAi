# 🧪 Firebase Setup Test Guide

## Quick Test Checklist

### ✅ Step 1: Test Web App with Firebase

```bash
cd JeduAi
flutter run -d chrome
```

**Expected Result:**
- App opens in Chrome
- No Firebase initialization errors in console
- Login screen appears

---

### ✅ Step 2: Test Student Signup

1. Click "Sign Up" button
2. Fill in details:
   - Name: `Test Student 1`
   - Email: `student1@test.com`
   - Password: `test123`
   - Role: `Student`
3. Click "Create Account"

**Expected Result:**
- Account created successfully
- Redirects to Student Dashboard
- No errors in console

**Verify in Firebase Console:**
1. Go to: https://console.firebase.google.com/project/jeduai-4b028
2. Click "Authentication" → "Users" tab
3. You should see: `student1@test.com`
4. Click "Firestore Database"
5. Check collections:
   - `users/[uid]` - Should have student data
   - `students/[uid]` - Should have student profile

---

### ✅ Step 3: Test Admin Login

1. Logout from student account
2. Click "Login"
3. Enter credentials:
   - Email: `admin@vsb.edu`
   - Password: `admin123`
   - Role: `Admin`
4. Click "Login"

**Expected Result:**
- Login successful
- Redirects to Admin Dashboard
- No errors in console

---

### ✅ Step 4: Test Admin Portal - View All Users

1. In Admin Dashboard, click "All Users Database"
2. Wait for data to load

**Expected Result:**
- Shows statistics: Total, Students, Staff, Admins
- Lists all registered users
- Shows "Source: Cloud (Firebase)" for users
- Can see the student you created in Step 2

**If you see the student:**
🎉 **SUCCESS!** Firebase is working correctly!

**If you don't see the student:**
❌ Check Firestore security rules (see FIRESTORE_SECURITY_RULES.txt)

---

### ✅ Step 5: Test Cross-Device Sync

#### On Device A (Chrome):
1. Sign up as: `student2@test.com`
2. Logout

#### On Device B (Another browser or device):
1. Login as admin: `admin@vsb.edu / admin123`
2. Go to "All Users Database"
3. Look for `student2@test.com`

**Expected Result:**
- Student from Device A appears in Device B
- This proves cloud sync is working!

---

### ✅ Step 6: Test Offline Fallback

1. Disconnect internet
2. Try to sign up as: `offline@test.com`

**Expected Result:**
- Account created locally
- Shows "Source: Local Storage" in admin portal
- When internet reconnects, can manually migrate to Firebase

---

## 🔍 Console Log Verification

### Good Logs (Success):
```
✅ Firebase initialized successfully
✅ Firebase Auth account created: [uid]
✅ User document created in users collection
✅ Student profile created in students collection
✅ Loaded X users from Firestore
```

### Bad Logs (Errors):
```
❌ Firebase initialization failed
❌ Permission denied (Firestore)
❌ Network error
```

**If you see errors:**
1. Check `firebase_options.dart` - correct API keys?
2. Check `google-services.json` - in correct location?
3. Check Firestore security rules - published?
4. Check internet connection

---

## 🎯 Success Criteria

Your Firebase setup is complete when:

- [x] Web app runs without Firebase errors
- [x] Students can sign up
- [x] Users appear in Firebase Console → Authentication
- [x] Users appear in Firebase Console → Firestore
- [x] Admin can see all users in "All Users Database"
- [x] Users show "Source: Cloud (Firebase)"
- [x] Cross-device sync works

---

## 🚨 Common Issues & Solutions

### Issue 1: "Firebase initialization failed"
**Cause**: Missing or incorrect configuration files

**Solution**:
```bash
# Check if google-services.json exists
ls JeduAi/android/app/google-services.json

# If missing, download from Firebase Console:
# Project Settings → Your apps → Android app → Download google-services.json
```

---

### Issue 2: "Permission denied" in Firestore
**Cause**: Security rules not applied

**Solution**:
1. Go to Firebase Console → Firestore Database → Rules
2. Copy rules from `FIRESTORE_SECURITY_RULES.txt`
3. Click "Publish"

---

### Issue 3: "Admin can't see users"
**Cause**: Admin not in Firestore admins collection

**Solution**:
1. Check Firebase Console → Firestore → `admins` collection
2. Should have document with email: `admin@vsb.edu`
3. If missing, restart the app (admin auto-creates on startup)

---

### Issue 4: "Users not syncing"
**Cause**: Using local storage instead of Firebase

**Solution**:
1. Check console logs - does it say "Firebase initialized successfully"?
2. If not, check `firebase_options.dart` configuration
3. Verify internet connection

---

## 📱 Test on Android Device

### Build APK:
```bash
cd JeduAi
flutter build apk --release
```

### Install on Device:
1. Transfer APK to device
2. Install and open
3. Sign up as new student
4. On another device, login as admin
5. Check if student appears in "All Users Database"

**Expected Result:**
- Student from mobile device appears in admin portal on web
- This proves Firebase cloud sync works across platforms!

---

## 🎉 Next Steps After Successful Test

1. ✅ Apply Firestore security rules (CRITICAL!)
2. ✅ Change default admin password
3. ✅ Build production APK
4. ✅ Deploy web app to Firebase Hosting
5. ✅ Submit to Google Play Store

See `FIREBASE_DEPLOYMENT_COMPLETE.md` for detailed deployment guide.

---

## 📊 Firebase Console Quick Links

- **Project Overview**: https://console.firebase.google.com/project/jeduai-4b028
- **Authentication**: https://console.firebase.google.com/project/jeduai-4b028/authentication/users
- **Firestore Database**: https://console.firebase.google.com/project/jeduai-4b028/firestore
- **Hosting**: https://console.firebase.google.com/project/jeduai-4b028/hosting

---

**Happy Testing! 🚀**
