# 🧪 Testing Online Class System

## Quick Diagnostic Steps

### Step 1: Check Console Output
After hot restart, you should see:
```
✅ Supabase initialized successfully
✅ Firebase initialized successfully
✅ Translation services initialized
✅ AI Tutor service initialized
✅ Shared Assessment Service initialized
✅ Media Translation Service initialized
✅ Online Class Controller initialized  ← LOOK FOR THIS
✅ Database initialized with automatic cleanup enabled
```

### Step 2: Test Class Creation
1. Login as staff: `vijayakumar@vsb.edu`
2. Go to Classes tab (bottom navigation)
3. Click "Schedule New" tab
4. Fill in the form
5. Click "Schedule Class"
6. Watch console for:
```
🔄 Controller: Creating class...
✅ Class created: CLS1733176176980 - Test Class
📊 Total classes: 3
📅 Upcoming classes: 3
✅ Controller: Class created successfully
```

### Step 3: Verify in Upcoming Tab
1. Click "Upcoming" tab
2. Should see the newly created class
3. If not visible, check console for errors

### Step 4: Check Student Portal
1. Logout
2. Login as student: `kathirvel@gmail.com`
3. Go to Classes tab
4. Check "Upcoming" or "My Classes" tab
5. Should see the class if auto-enrolled

---

## Common Issues & Solutions

### Issue 1: "Get.find<OnlineClassService>() not found"
**Symptom:** Error when opening Classes tab
**Solution:**
```dart
// In main.dart, ensure this order:
Get.put(OnlineClassService(), permanent: true);  // Service first
Get.put(OnlineClassController(), permanent: true); // Controller second
```

### Issue 2: Classes not appearing after creation
**Symptom:** Success dialog shows but Upcoming tab is empty
**Solution:** Hot restart the app (press 'R' in terminal)

### Issue 3: "Creating class..." dialog stuck
**Symptom:** Loading dialog doesn't close
**Check:** Console for error messages
**Solution:** Ensure all required fields are filled

### Issue 4: Controller not initialized
**Symptom:** Error accessing classController
**Solution:** 
```dart
// Use lazy getter instead of final field
OnlineClassController get classController => Get.find<OnlineClassController>();
```

---

## Manual Test Procedure

### Test 1: Basic Class Creation
```
✓ Login as staff
✓ Navigate to Classes
✓ Click Schedule New
✓ Enter title: "Test Class 1"
✓ Select subject: "Computer Science"
✓ Select class: "III CSBS"
✓ Set date: Today
✓ Set time: Current time + 10 minutes
✓ Duration: 60 minutes
✓ Click Schedule Class
✓ Verify success dialog appears
✓ Verify class appears in Upcoming tab
```

### Test 2: Cross-Portal Verification
```
✓ Create class as staff
✓ Note class code (e.g., COM-1361)
✓ Logout
✓ Login as student
✓ Go to Classes → Upcoming
✓ Verify class appears
✓ Logout
✓ Login as admin
✓ Go to Classes → All
✓ Verify class appears
```

### Test 3: Multiple Classes
```
✓ Create 3 classes with different subjects
✓ All should appear in Upcoming tab
✓ Check count matches (e.g., "Upcoming (3)")
✓ Each class should have unique code
✓ Meeting links should be different
```

---

## Debug Commands

### In Browser Console (F12):
```javascript
// Check if service exists
console.log(window.flutter_service_worker);

// Force reload
location.reload();
```

### In Terminal:
```bash
# Hot reload
r

# Hot restart (recommended)
R

# Clear and restart
q
flutter run -d chrome
```

---

## Expected Console Output

### On App Start:
```
✅ Supabase initialized successfully
✅ Firebase initialized successfully
✅ Translation services initialized
✅ AI Tutor service initialized
✅ Shared Assessment Service initialized
✅ Media Translation Service initialized
✅ Online Class Controller initialized
✅ Database initialized with automatic cleanup enabled
```

### On Class Creation:
```
🔄 Controller: Creating class...
✅ Class created: CLS1733176176980 - Data Science Fundamentals
📊 Total classes: 3
📅 Upcoming classes: 3
✅ Controller: Class created successfully
```

### On Navigation to Classes Tab:
```
(No errors should appear)
```

---

## Verification Checklist

### Before Testing:
- [ ] App is running on Chrome
- [ ] No red errors in console
- [ ] Can see login screen
- [ ] Can login successfully

### During Class Creation:
- [ ] All form fields are fillable
- [ ] Subject dropdown shows 70+ options
- [ ] Class dropdown shows all classes
- [ ] Date picker works
- [ ] Time picker works
- [ ] Duration slider works
- [ ] Meeting link auto-generates
- [ ] Can copy meeting link

### After Class Creation:
- [ ] Success dialog appears
- [ ] Class code is shown
- [ ] Meeting link is shown
- [ ] Can click "View Classes"
- [ ] Class appears in Upcoming tab
- [ ] Class details are correct
- [ ] Can copy link from class card
- [ ] Participant count shows correctly

### Cross-Portal Check:
- [ ] Class visible in staff portal
- [ ] Class visible in student portal (if enrolled)
- [ ] Class visible in admin portal
- [ ] All portals show same data
- [ ] Counts match across portals

---

## If Still Not Working

### Step 1: Full Restart
```bash
# In terminal, press 'q' to quit
# Then run:
flutter clean
flutter pub get
flutter run -d chrome
```

### Step 2: Check Dependencies
```bash
flutter doctor
flutter pub outdated
```

### Step 3: Verify GetX Setup
```dart
// In main.dart, ensure GetMaterialApp is used:
return GetMaterialApp(
  title: 'JeduAI',
  // ...
);
```

### Step 4: Check Service Registration
```dart
// Add this in main.dart after initialization:
print('Services registered:');
print('- UserService: ${Get.isRegistered<UserService>()}');
print('- OnlineClassService: ${Get.isRegistered<OnlineClassService>()}');
print('- OnlineClassController: ${Get.isRegistered<OnlineClassController>()}');
```

---

## Success Indicators

✅ No errors in console
✅ Can create classes
✅ Success dialog shows
✅ Classes appear in Upcoming tab
✅ Classes visible across all portals
✅ Can copy meeting links
✅ Participant counts are correct
✅ Auto-enrollment works
✅ Notifications appear

---

## Contact Points

If issues persist after all steps:
1. Check console for specific error messages
2. Try different browser (Firefox, Edge)
3. Check network tab for failed requests
4. Verify all files are saved
5. Try incognito/private mode

The system should work after hot restart (R) with proper initialization!
