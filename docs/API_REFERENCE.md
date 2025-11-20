# JeduAI API Reference

## Overview

This document provides detailed information about the JeduAI API endpoints, services, and data models.

## Table of Contents

1. [Authentication](#authentication)
2. [User Management](#user-management)
3. [Online Classes](#online-classes)
4. [Assessments](#assessments)
5. [Notifications](#notifications)
6. [Translation](#translation)
7. [Video Conferencing](#video-conferencing)
8. [Error Handling](#error-handling)

## Authentication

### Login User

**Method**: `authenticateUser()`

**Parameters**:
- `email` (String): User email address
- `password` (String): User password
- `role` (UserRole): User role (admin, staff, student)

**Returns**: `User?` - User object or null if authentication fails

**Example**:
```dart
final user = await DatabaseService().authenticateUser(
  email: 'mpkathir@gmail.com',
  password: 'password123',
  role: UserRole.admin
);
```

### Logout User

**Method**: `logout()`

**Example**:
```dart
UserService().logout();
```

## User Management

### Get All Users

**Method**: `getAllUsers()`

**Returns**: `List<User>` - List of all users

**Example**:
```dart
final users = await DatabaseService().getAllUsers();
```

### Get User by ID

**Method**: `getUserById(String userId)`

**Parameters**:
- `userId` (String): Unique user identifier

**Returns**: `User?` - User object or null if not found

**Example**:
```dart
final user = UserService().getUserById('USR001');
```

### Update User Profile

**Method**: `updateUser(User user)`

**Parameters**:
- `user` (User): Updated user object

**Example**:
```dart
UserService().updateUser(updatedUser);
```

## Online Classes

### Create Online Class

**Method**: `createOnlineClass()`

**Parameters**:
- `title` (String): Class title
- `subject` (String): Subject name
- `teacherId` (String): Teacher's user ID
- `teacherName` (String): Teacher's name
- `scheduledTime` (DateTime): When the class is scheduled
- `duration` (int): Duration in minutes
- `description` (String): Class description
- `maxStudents` (int): Maximum number of students

**Returns**: `String` - Created class ID

**Example**:
```dart
final classId = await DatabaseService().createOnlineClass(
  title: 'Advanced Mathematics',
  subject: 'Mathematics',
  teacherId: 'STF001',
  teacherName: 'Kathirvel P',
  scheduledTime: DateTime.now().add(Duration(hours: 2)),
  duration: 60,
  description: 'Advanced calculus concepts',
  maxStudents: 30,
);
```

### Get All Online Classes

**Method**: `getAllOnlineClasses()`

**Returns**: `List<OnlineClass>` - List of all online classes

**Example**:
```dart
final classes = await DatabaseService().getAllOnlineClasses();
```

### Enroll in Class

**Method**: `enrollInClass(String classId, String studentId)`

**Parameters**:
- `classId` (String): Class identifier
- `studentId` (String): Student identifier

**Example**:
```dart
await DatabaseService().enrollInClass('CLS001', 'STU001');
```

### Update Class Status

**Method**: `updateClassStatus(String classId, ClassStatus status)`

**Parameters**:
- `classId` (String): Class identifier
- `status` (ClassStatus): New status (scheduled, live, completed, cancelled)

**Example**:
```dart
await DatabaseService().updateClassStatus('CLS001', ClassStatus.live);
```

### Get Class Enrollments

**Method**: `getClassEnrollments(String classId)`

**Parameters**:
- `classId` (String): Class identifier

**Returns**: `List<String>` - List of enrolled student IDs

**Example**:
```dart
final enrollments = await DatabaseService().getClassEnrollments('CLS001');
```

## Assessments

### Create Assessment

**Method**: `createAssessment()`

**Parameters**:
- `title` (String): Assessment title
- `subject` (String): Subject name
- `teacherId` (String): Teacher's ID
- `description` (String): Assessment description
- `dueDate` (DateTime): Due date
- `totalMarks` (int): Total marks
- `questions` (List<Map<String, dynamic>>): List of questions

**Returns**: `String` - Created assessment ID

**Example**:
```dart
final assessmentId = await DatabaseService().createAssessment(
  title: 'Algebra Quiz',
  subject: 'Mathematics',
  teacherId: 'STF001',
  description: 'Basic algebra concepts',
  dueDate: DateTime.now().add(Duration(days: 7)),
  totalMarks: 100,
  questions: [
    {
      'question': 'What is 2 + 2?',
      'options': ['3', '4', '5', '6'],
      'correct': 1,
      'marks': 10
    }
  ],
);
```

## Notifications

### Send Notification

**Method**: `sendNotification()`

**Parameters**:
- `title` (String): Notification title
- `message` (String): Notification message
- `category` (NotificationCategory): Notification category
- `recipientIds` (List<String>): List of recipient user IDs
- `actionId` (String?): Optional related item ID
- `data` (Map<String, dynamic>?): Optional additional data

**Example**:
```dart
NotificationService().sendNotification(
  title: 'New Class Scheduled',
  message: 'Mathematics class at 2 PM today',
  category: NotificationCategory.classScheduled,
  recipientIds: ['STU001', 'STU002'],
  actionId: 'CLS001',
);
```

### Broadcast Notification

**Method**: `broadcastNotification()`

**Parameters**:
- `title` (String): Notification title
- `message` (String): Notification message
- `category` (NotificationCategory): Notification category
- `actionId` (String?): Optional related item ID

**Example**:
```dart
NotificationService().broadcastNotification(
  title: 'System Maintenance',
  message: 'System will be down for maintenance at 10 PM',
  category: NotificationCategory.system,
);
```

### Get User Notifications

**Method**: `getNotificationsForUser(String userId)`

**Parameters**:
- `userId` (String): User identifier

**Returns**: `List<SystemNotification>` - List of notifications

**Example**:
```dart
final notifications = await DatabaseService().getNotificationsForUser('STU001');
```

## Translation

### Translate Text

**Method**: `translate()`

**Parameters**:
- `text` (String): Text to translate
- `sourceLanguage` (String): Source language
- `targetLanguage` (String): Target language

**Returns**: `String` - Translated text

**Example**:
```dart
final translation = await TranslationController().translate(
  text: 'Hello, how are you?',
  sourceLanguage: 'English',
  targetLanguage: 'Hindi'
);
```

### Save Translation

**Method**: `saveTranslation()`

**Parameters**:
- `sourceText` (String): Original text
- `targetText` (String): Translated text
- `sourceLanguage` (String): Source language
- `targetLanguage` (String): Target language
- `userId` (String): User ID

**Example**:
```dart
await DatabaseService().saveTranslation(
  sourceText: 'Hello',
  targetText: 'नमस्ते',
  sourceLanguage: 'English',
  targetLanguage: 'Hindi',
  userId: 'STU001',
);
```

### Get Translation History

**Method**: `getTranslationHistory(String userId)`

**Parameters**:
- `userId` (String): User identifier

**Returns**: `List<Map<String, dynamic>>` - Translation history

**Example**:
```dart
final history = await DatabaseService().getTranslationHistory('STU001');
```

## Video Conferencing

### Start Meeting

**Method**: `startMeeting(String meetingId)`

**Parameters**:
- `meetingId` (String): Meeting identifier

**Example**:
```dart
VideoConferenceService().startMeeting('JED-123456');
```

### Join Meeting

**Method**: `joinMeeting(String meetingId, String userId, String userName)`

**Parameters**:
- `meetingId` (String): Meeting identifier
- `userId` (String): User ID
- `userName` (String): User name

**Example**:
```dart
VideoConferenceService().joinMeeting('JED-123456', 'STU001', 'Kathirvel P');
```

### Toggle Camera

**Method**: `toggleCamera()`

**Example**:
```dart
VideoConferenceService().toggleCamera();
```

### Toggle Microphone

**Method**: `toggleMicrophone()`

**Example**:
```dart
VideoConferenceService().toggleMicrophone();
```

### Send Chat Message

**Method**: `saveChatMessage()`

**Parameters**:
- `meetingId` (String): Meeting identifier
- `senderId` (String): Sender user ID
- `senderName` (String): Sender name
- `message` (String): Chat message

**Example**:
```dart
await DatabaseService().saveChatMessage(
  meetingId: 'JED-123456',
  senderId: 'STU001',
  senderName: 'Kathirvel P',
  message: 'Hello everyone!',
);
```

### Get Chat Messages

**Method**: `getChatMessages(String meetingId)`

**Parameters**:
- `meetingId` (String): Meeting identifier

**Returns**: `List<Map<String, dynamic>>` - Chat messages

**Example**:
```dart
final messages = await DatabaseService().getChatMessages('JED-123456');
```

## Error Handling

### Error Response Format

All API errors follow this format:

```dart
try {
  // API call
} catch (e) {
  print('Error: $e');
  // Handle error appropriately
}
```

### Common Error Codes

- **Authentication Failed**: Invalid credentials
- **Not Found**: Resource doesn't exist
- **Permission Denied**: Insufficient permissions
- **Validation Error**: Invalid input data
- **Server Error**: Internal server error

### Best Practices

1. Always wrap API calls in try-catch blocks
2. Provide user-friendly error messages
3. Log errors for debugging
4. Implement retry logic for network errors
5. Handle offline scenarios gracefully

## Real-time Subscriptions

### Subscribe to Classes

**Method**: `subscribeToClasses()`

**Returns**: `Stream<List<Map<String, dynamic>>>` - Real-time class updates

**Example**:
```dart
DatabaseService().subscribeToClasses().listen((classes) {
  // Handle class updates
  print('Classes updated: ${classes.length}');
});
```

### Subscribe to Notifications

**Method**: `subscribeToNotifications(String userId)`

**Parameters**:
- `userId` (String): User identifier

**Returns**: `Stream<List<Map<String, dynamic>>>` - Real-time notifications

**Example**:
```dart
DatabaseService().subscribeToNotifications('STU001').listen((notifications) {
  // Handle new notifications
  print('New notifications: ${notifications.length}');
});
```

## Data Models

### User Model

```dart
class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final String? department;
  final List<String>? subjects;
  final String? className;
  final String? rollNumber;
  final DateTime joinDate;
}
```

### OnlineClass Model

```dart
class OnlineClass {
  final String id;
  final String title;
  final String subject;
  final String teacherId;
  final String teacherName;
  final DateTime scheduledTime;
  final int duration;
  final String meetingLink;
  final ClassStatus status;
  final List<String> enrolledStudents;
  final int maxStudents;
  final String description;
  final String classCode;
}
```

### Assessment Model

```dart
class Assessment {
  final String id;
  final String title;
  final String subject;
  final String teacherId;
  final String description;
  final DateTime dueDate;
  final int totalMarks;
  final List<Question> questions;
}
```

### Notification Model

```dart
class SystemNotification {
  final String id;
  final String title;
  final String message;
  final NotificationCategory category;
  final List<String> recipientIds;
  final DateTime timestamp;
  final String? actionId;
  final Map<String, dynamic>? data;
}
```

## Rate Limiting

Currently, there are no rate limits implemented. However, best practices include:

- Implement debouncing for frequent operations
- Cache data when possible
- Use pagination for large datasets
- Implement exponential backoff for retries

## Versioning

API Version: 1.0.0

Future versions will maintain backward compatibility where possible.

---

**Last Updated**: December 2024
