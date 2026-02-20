# How to View All Users Database

## Quick Access

### From Student Dashboard:
1. Login as any user (student/staff/admin)
2. Look at the top-right corner of the dashboard
3. Click the **database icon** (📊 storage icon) next to notifications
4. You'll see the "All Users Database" view

### From Admin Dashboard:
1. Login as admin
2. Scroll down to "Quick Management" section
3. Click the **"All Users Database"** button (purple gradient card)
4. You'll see all registered users

## What You Can See

The All Users Database view shows:

### Statistics Header
- **Total Users**: Count of all registered users
- **Students**: Number of student accounts
- **Staff**: Number of staff accounts  
- **Admins**: Number of admin accounts

### Filter Options
- View **All** users
- Filter by **Students** only
- Filter by **Staff** only
- Filter by **Admins** only

### User Cards
Each user card displays:
- User avatar (first letter of name)
- Full name
- Email address
- Role badge (color-coded)
- User ID
- Creation date
- Department, Year, Section (if applicable)
- Designation (for staff)

### Actions Available
- **View Full Data**: See complete JSON data for the user
- **Delete User**: Remove user from database (with confirmation)
- **Refresh**: Reload all users from storage
- **Database Info**: View storage location and technical details

## Where is the Data Stored?

### Storage Type
**Local Storage (SharedPreferences)**

### Storage Key
`local_users`

### Physical Location

**Android:**
```
/data/data/com.example.jeduai_app1/shared_prefs/FlutterSharedPreferences.xml
```

**iOS:**
```
Library/Preferences/FlutterSharedPreferences.plist
```

**Web:**
```
Browser LocalStorage (F12 > Application > Local Storage)
```

**Windows:**
```
%APPDATA%\com.example\jeduai_app1\shared_preferences.json
```

## How to Access Raw Data

### Method 1: Using Flutter DevTools
1. Run app in debug mode: `flutter run`
2. Open DevTools
3. Go to "App Inspector"
4. Search for SharedPreferences

### Method 2: Using ADB (Android)
```bash
# Connect device
adb devices

# Pull the preferences file
adb pull /data/data/com.example.jeduai_app1/shared_prefs/FlutterSharedPreferences.xml

# View the file
cat FlutterSharedPreferences.xml
```

### Method 3: Using App (Easiest)
1. Open the app
2. Go to "All Users Database" view
3. Click any user card to expand
4. Click "View Full Data" button
5. You'll see complete JSON data that you can copy

### Method 4: Programmatically
```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> viewAllUsers() async {
  final prefs = await SharedPreferences.getInstance();
  final usersJson = prefs.getString('local_users') ?? '[]';
  final List<dynamic> users = jsonDecode(usersJson);
  
  print('Total Users: ${users.length}');
  for (var user in users) {
    print(jsonEncode(user));
  }
}
```

## User Data Structure

Each user object contains:
```json
{
  "uid": "1234567890",
  "name": "John Doe",
  "email": "john@example.com",
  "password": "hashed_password",
  "role": "student",
  "createdAt": "2024-02-20T10:30:00.000Z",
  "updatedAt": "2024-02-20T10:30:00.000Z",
  "department": "Computer Science",
  "year": "3rd Year",
  "section": "A",
  "enrolledCourses": [],
  "completedAssessments": [],
  "totalScore": 0,
  "averageScore": 0.0
}
```

## User Analytics Data

Each user's analytics are stored separately:
- **Storage Key**: `user_analytics_{uid}`
- **Contains**: 
  - assessmentsCompleted
  - videosWatched
  - translationsUsed
  - averageScore
  - totalScore
  - loginCount
  - lastLoginDate

## Important Notes

⚠️ **Local Storage Only**
- Data is stored ONLY on the device where the app is installed
- If you uninstall the app, all data is lost
- Data is NOT synced across devices
- Data is NOT backed up to cloud

✅ **For Production Use**
- Configure Firebase Authentication + Firestore
- Or configure Supabase (PostgreSQL database)
- This will enable cloud storage and multi-device sync

🔒 **Security Note**
- Passwords are stored in plain text (for demo purposes)
- In production, passwords should be hashed
- Use Firebase Auth or proper authentication service

## Troubleshooting

**Q: I don't see any users**
- Make sure you've registered at least one account
- Click the refresh button (top-right)
- Check if you're filtering by a specific role

**Q: Can I export the data?**
- Yes, click "View Full Data" on any user
- Copy the JSON text
- Save to a file

**Q: Can I import users?**
- Not through the UI currently
- You can programmatically add users via LocalAuthService

**Q: How do I backup the data?**
- Use ADB to pull the SharedPreferences file (Android)
- Or implement cloud sync with Firebase/Supabase
