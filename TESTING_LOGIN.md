# Testing Login Functionality

## Overview
The login system now includes role-based authentication that redirects users to different dashboards based on their role.

## How It Works

1. **User Login**: User enters email, password, and selects their role (Student/Staff/Admin)
2. **Authentication**: Firebase Auth verifies credentials
3. **Role Verification**: System fetches user role from Firestore and verifies it matches the selected role
4. **Navigation**: User is redirected to the appropriate dashboard:
   - Student → `/student/dashboard`
   - Staff → `/staff/dashboard`
   - Admin → `/admin/dashboard`

## Setting Up Test Users in Firestore

To test the login functionality, you need to create user documents in Firestore:

### Firestore Structure
```
users (collection)
  └── {userId} (document)
      ├── email: "user@example.com"
      ├── role: "Student" | "Staff" | "Admin"
      ├── name: "User Name"
      └── ... (other user fields)
```

### Steps to Create Test Users:

1. Go to Firebase Console → Firestore Database
2. Create a collection named `users`
3. For each test user:
   - Create a document with the user's UID (from Firebase Auth)
   - Add fields:
     - `email`: user's email
     - `role`: "Student", "Staff", or "Admin"
     - `name`: user's display name

### Example Test Users:

**Student Account:**
- Email: student@jeduai.com
- Password: student123
- Role: Student

**Staff Account:**
- Email: staff@jeduai.com
- Password: staff123
- Role: Staff

**Admin Account:**
- Email: admin@jeduai.com
- Password: admin123
- Role: Admin

## Testing the Login

1. Run the app: `flutter run`
2. On the login screen:
   - Select a role from the dropdown
   - Enter email and password
   - Click "Login"
3. Verify:
   - Loading indicator appears
   - User is redirected to the correct dashboard
   - If role mismatch, error message is shown

## Error Handling

The system handles these scenarios:
- **Wrong credentials**: Shows Firebase error message
- **Role mismatch**: Shows error and signs user out
- **User not in Firestore**: Uses selected role (with warning)
- **Network errors**: Shows appropriate error message

## Troubleshooting

If login doesn't work:
1. Check Firebase Console for authentication errors
2. Verify Firestore rules allow read access to user documents
3. Ensure user document exists with correct role field
4. Check console logs for detailed error messages
