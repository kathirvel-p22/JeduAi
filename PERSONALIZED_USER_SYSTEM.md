# Personalized User System - JeduAI

## Overview
JeduAI now has a complete personalized user system where each user has their own account, data, analytics, and profile. Multiple users can register and use the app with their own isolated data.

## Features Implemented

### 1. **User Session Management**
- `UserSessionService` tracks the currently logged-in user
- Stores user data in local storage (SharedPreferences)
- Persists across app restarts
- Automatic session restoration on app launch

### 2. **User Registration & Login**
- **Sign Up**: New users can create accounts with:
  - Name
  - Email
  - Password
  - Role (Student/Staff/Admin)
- **Login**: Existing users login with email and password
- **Multiple Accounts**: Unlimited users can register
- **Data Isolation**: Each user only sees their own data

### 3. **Personalized Analytics**
Each user has their own tracked metrics:
- **Assessments Completed**: Number of quizzes/tests taken
- **Videos Watched**: Count of educational videos viewed
- **Translations Used**: Number of translations performed
- **Average Score**: Calculated from all assessments
- **Total Score**: Sum of all assessment scores
- **Login Count**: Number of times user has logged in
- **Last Login Date**: Timestamp of most recent login

### 4. **User Profile**
Personalized profile page showing:
- User information (name, email, role, ID)
- Statistics dashboard with visual cards
- Activity history
- Edit profile functionality
- Department, year, section (for students)
- Designation, subjects (for staff)
- Permissions (for admins)

### 5. **Data Tracking**
Automatic tracking of user activities:
```dart
// Track assessment completion
await UserSessionService.instance.trackAssessmentCompleted(score);

// Track video watched
await UserSessionService.instance.trackVideoWatched();

// Track translation used
await UserSessionService.instance.trackTranslationUsed();
```

## File Structure

```
lib/
├── services/
│   ├── user_session_service.dart      # User session management
│   └── local_auth_service.dart        # Local authentication
├── views/
│   └── student/
│       └── personalized_profile_view.dart  # User profile page
└── controllers/
    └── auth_controller.dart           # Updated with session management
```

## How It Works

### Registration Flow
1. User fills signup form
2. System creates account in local storage
3. User data stored with unique ID
4. Role-specific data initialized
5. Success dialog shown
6. Redirect to login

### Login Flow
1. User enters credentials
2. System validates against stored users
3. If valid, creates user session
4. Loads user analytics
5. Increments login count
6. Updates last login date
7. Navigates to role-specific dashboard

### Dashboard Flow
1. Dashboard loads current user session
2. Displays personalized greeting
3. Shows user-specific statistics
4. All actions tracked automatically
5. Data saved to user's analytics

### Profile Flow
1. Profile page loads from session
2. Displays user information
3. Shows statistics with visual cards
4. Activity history displayed
5. Edit profile updates session and storage

## Usage Examples

### Access Current User
```dart
final session = UserSessionService.instance;

// Get user info
String name = session.userName;
String email = session.userEmail;
String role = session.userRole;
bool loggedIn = session.isLoggedIn;

// Get statistics
int assessments = session.assessmentsCompleted.value;
double avgScore = session.averageScore.value;
int videos = session.videosWatched.value;
```

### Track User Activity
```dart
// In assessment completion
await session.trackAssessmentCompleted(85); // Score: 85

// In video player
await session.trackVideoWatched();

// In translation feature
await session.trackTranslationUsed();
```

### Update User Profile
```dart
await session.updateUserProfile({
  'department': 'Computer Science',
  'year': '3rd Year',
  'section': 'A',
});
```

## Data Storage

### User Data Structure
```json
{
  "uid": "1708123456789",
  "name": "John Doe",
  "email": "john@example.com",
  "password": "hashed_password",
  "role": "student",
  "createdAt": "2026-02-17T10:30:00.000Z",
  "updatedAt": "2026-02-17T10:30:00.000Z",
  "department": "Computer Science",
  "year": "3rd Year",
  "section": "A"
}
```

### Analytics Data Structure
```json
{
  "assessmentsCompleted": 5,
  "videosWatched": 12,
  "translationsUsed": 8,
  "averageScore": 82.5,
  "totalScore": 412,
  "loginCount": 15,
  "lastLoginDate": "2026-02-17T10:30:00.000Z",
  "updatedAt": "2026-02-17T10:30:00.000Z"
}
```

## Testing the System

### Test Scenario 1: Multiple Users
1. **User A** signs up as Student
   - Email: alice@example.com
   - Completes 3 assessments
   - Watches 5 videos
   - Logs out

2. **User B** signs up as Student
   - Email: bob@example.com
   - Completes 2 assessments
   - Watches 3 videos
   - Logs out

3. **User A** logs back in
   - Sees their own 3 assessments
   - Sees their own 5 videos
   - User B's data is NOT visible

### Test Scenario 2: Analytics Tracking
1. Login as any user
2. Complete an assessment → Count increases
3. Watch a video → Count increases
4. Use translation → Count increases
5. Check profile → All stats updated
6. Logout and login → Stats persisted

### Test Scenario 3: Profile Management
1. Login as user
2. Go to profile page
3. View statistics dashboard
4. Click "Edit Profile"
5. Update information
6. Save changes
7. Profile updated immediately

## Benefits

### For Users
- ✅ Personal account with own data
- ✅ Track learning progress
- ✅ See performance analytics
- ✅ Customize profile
- ✅ Privacy - data isolation

### For Developers
- ✅ Easy to track user behavior
- ✅ Simple analytics integration
- ✅ Scalable architecture
- ✅ Works offline (local storage)
- ✅ Firebase-ready (easy migration)

## Future Enhancements

### Planned Features
1. **Cloud Sync**: Sync data to Firebase when configured
2. **Achievements**: Badges for milestones
3. **Leaderboards**: Compare with other users
4. **Progress Charts**: Visual progress over time
5. **Export Data**: Download user data as PDF
6. **Social Features**: Share achievements
7. **Notifications**: Personalized reminders
8. **Recommendations**: AI-based learning suggestions

### Migration to Firebase
When Firebase is configured, the system will:
1. Automatically sync local data to cloud
2. Enable real-time updates
3. Support multi-device access
4. Backup user data
5. Enable advanced analytics

## API Reference

### UserSessionService Methods

```dart
// Session Management
await setCurrentUser(Map<String, dynamic> user)
await clearCurrentUser()
await loadCurrentUser()

// Analytics
await trackAssessmentCompleted(int score)
await trackVideoWatched()
await trackTranslationUsed()
await incrementLoginCount()
await updateLastLoginDate()

// Profile
await updateUserProfile(Map<String, dynamic> updates)
await loadUserAnalytics()
await saveUserAnalytics()

// Getters
String get userName
String get userEmail
String get userRole
String get userId
bool get isLoggedIn
Map<String, dynamic> get userProfile
Map<String, dynamic> get userStatistics
```

## Troubleshooting

### Issue: User data not persisting
**Solution**: Check SharedPreferences permissions

### Issue: Analytics not updating
**Solution**: Ensure `saveUserAnalytics()` is called after tracking

### Issue: Profile not showing
**Solution**: Verify user is logged in with `isLoggedIn`

### Issue: Multiple users seeing same data
**Solution**: Check user ID is unique and properly set

## Support

For issues or questions:
1. Check console logs for error messages
2. Verify user session is active
3. Check local storage data
4. Review FIREBASE_SETUP_GUIDE.md for cloud sync

---

**Made with ❤️ for JeduAI - Personalized Learning Experience**
