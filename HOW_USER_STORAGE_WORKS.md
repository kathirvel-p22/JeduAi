# How User Storage Works in JeduAI

## Understanding Local Storage

Your JeduAI app uses **SharedPreferences** (browser's LocalStorage for web) to store user data.

### Important: Browser Storage is Isolated

- Each browser stores data separately
- Chrome data ≠ Firefox data
- Incognito mode has separate storage
- Clearing browser data deletes all users

---

## How to Test User Signup & Admin View

### Step 1: Sign Up New Users

1. **Open the app**: http://localhost:8080
2. **Click "Sign Up"** or "Register"
3. **Fill in details**:
   - Name: Test Student
   - Email: teststudent@example.com
   - Password: 123456
   - Role: Student
4. **Click "Sign Up"**
5. **User is saved** to browser's LocalStorage

### Step 2: View Users in Admin Portal

1. **Logout** from the student account
2. **Login as Admin**:
   - Email: admin@vsb.edu
   - Password: any password
   - Role: Admin
3. **Go to Admin Dashboard**
4. **Click "All Users Database"** button (purple card)
5. **You should see**:
   - The new student you just created
   - All previously registered users

---

## Checking Browser Storage Directly

### View Stored Users in Browser:

1. **Open Chrome DevTools**: Press F12
2. **Go to "Application" tab**
3. **Expand "Local Storage"** in left sidebar
4. **Click on your app's URL** (http://localhost:8080)
5. **Look for key**: `flutter.local_users`
6. **Click on it** to see all registered users in JSON format

### Example of what you'll see:
```json
[
  {
    "uid": "1708123456789",
    "name": "Test Student",
    "email": "teststudent@example.com",
    "password": "123456",
    "role": "student",
    "createdAt": "2024-02-16T10:30:00.000Z",
    "department": "",
    "year": "",
    "section": ""
  },
  {
    "uid": "1708123456790",
    "name": "Admin User",
    "email": "admin@vsb.edu",
    "password": "admin123",
    "role": "admin",
    "createdAt": "2024-02-16T10:31:00.000Z"
  }
]
```

---

## Troubleshooting

### Issue: New users not showing in admin portal

**Possible Causes:**

1. **Different Browser/Incognito Mode**
   - Solution: Use the same browser window for signup and admin login

2. **Browser Cache Cleared**
   - Solution: Sign up users again

3. **App Not Refreshing**
   - Solution: Click the "Refresh" button in All Users Database view

4. **Using Different Ports**
   - Solution: Make sure you're on the same URL (http://localhost:8080)

### Issue: Users disappear after closing browser

**Cause**: This is normal for web apps using LocalStorage

**Solutions**:
1. **For Development**: Users persist as long as you don't clear browser data
2. **For Production**: Use Firebase or Supabase (cloud database)

---

## Testing Workflow

### Complete Test Scenario:

```
1. Open app → http://localhost:8080
2. Sign up as Student:
   - Name: John Doe
   - Email: john@example.com
   - Password: 123456
   - Role: Student
   
3. Logout

4. Sign up as Staff:
   - Name: Jane Smith
   - Email: jane@example.com
   - Password: 123456
   - Role: Staff
   
5. Logout

6. Login as Admin:
   - Email: admin@vsb.edu
   - Password: any password
   - Role: Admin
   
7. Click "All Users Database" button

8. You should see:
   ✅ John Doe (Student)
   ✅ Jane Smith (Staff)
   ✅ Admin User (Admin)
   ✅ Any other users you created
```

---

## Verifying User Storage

### Method 1: Browser DevTools (Easiest)

```
F12 → Application → Local Storage → flutter.local_users
```

### Method 2: In-App (Admin Portal)

```
Login as Admin → All Users Database → See all users
```

### Method 3: Console Logging

Open browser console (F12 → Console) and type:
```javascript
localStorage.getItem('flutter.local_users')
```

---

## Why Users Might Not Show

### Common Mistakes:

1. ❌ **Signing up in one browser, checking in another**
   - ✅ Use the same browser

2. ❌ **Using incognito mode**
   - ✅ Use regular browser window

3. ❌ **Clearing browser data between signup and admin check**
   - ✅ Don't clear browser data

4. ❌ **Not refreshing the All Users view**
   - ✅ Click the refresh button

5. ❌ **Checking on different port/URL**
   - ✅ Use same URL (http://localhost:8080)

---

## For Production (Cloud Storage)

If you want users to persist across devices and browsers, you need cloud storage:

### Option 1: Firebase (Recommended)
- Users stored in Firestore
- Accessible from any device
- Real-time sync
- See: FIREBASE_SETUP_GUIDE.md

### Option 2: Supabase
- PostgreSQL database
- RESTful API
- Real-time subscriptions
- See: SUPABASE_INTEGRATION_COMPLETE.md

### Option 3: Your Own Backend
- Node.js + MongoDB
- Python + PostgreSQL
- Any backend you prefer

---

## Quick Test Commands

### Clear All Users (Start Fresh):
```javascript
// In browser console (F12 → Console)
localStorage.removeItem('flutter.local_users')
```

### View All Users:
```javascript
// In browser console
console.log(JSON.parse(localStorage.getItem('flutter.local_users')))
```

### Count Users:
```javascript
// In browser console
JSON.parse(localStorage.getItem('flutter.local_users')).length
```

---

## Summary

✅ **User signup works** - saves to browser LocalStorage
✅ **Admin can view all users** - through "All Users Database"
✅ **Data persists** - until browser data is cleared
✅ **Each browser is separate** - Chrome ≠ Firefox ≠ Incognito

**For your use case**: The system is working correctly! Just make sure you:
1. Sign up users in the same browser
2. Login as admin in the same browser
3. Click "All Users Database" to see all registered users

**Need cloud storage?** Set up Firebase or Supabase for production use.
