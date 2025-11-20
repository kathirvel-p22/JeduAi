# JeduAI Quick Reference Guide

## 🚀 Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run

# 3. Login
Admin: mpkathir@gmail.com
Staff: kathirvel.staff@jeduai.com
Student: kathirvel.student@jeduai.com
Password: any
```

---

## 📦 Key Services

### Database Service
```dart
// Get instance
final db = Get.find<DatabaseService>();

// Create online class
await db.createOnlineClass(
  title: 'Math Class',
  subject: 'Mathematics',
  teacherId: 'TCH001',
  teacherName: 'Prof. Kumar',
  scheduledTime: DateTime.now().add(Duration(hours: 2)),
  duration: 60,
  description: 'Algebra basics',
  maxStudents: 50,
  meetingLink: 'https://meet.jeduai.com/JED-123456',
  classCode: 'MATH-1234',
);

// Manual cleanup
await db.manualCleanup();
```

### Advanced Analytics
```dart
// Get instance
final analytics = Get.find<AdvancedAnalyticsService>();

// Student analytics
final studentData = await analytics.getStudentAnalytics('STU001');
print('Average Score: ${studentData['averageScore']}');

// Teacher analytics
final teacherData = await analytics.getTeacherAnalytics('TCH001');
print('Total Classes: ${teacherData['totalClasses']}');

// System analytics
final systemData = await analytics.getSystemAnalytics();
print('Total Users: ${systemData['totalUsers']}');

// Export to CSV
final csv = analytics.exportToCSV(studentData, 'student');
```

### AI Recommendations
```dart
// Get instance
final ai = Get.find<AIRecommendationService>();

// Class recommendations
final classRecs = await ai.getClassRecommendations('STU001');
for (var rec in classRecs) {
  print('${rec['title']} - ${rec['recommendationReason']}');
}

// Study recommendations
final studyRecs = await ai.getStudyRecommendations('STU001');

// Learning path
final path = await ai.getPersonalizedLearningPath('STU001');

// Teacher recommendations
final teacherRecs = await ai.getTeacherRecommendations('TCH001');

// Smart scheduling
final schedule = await ai.getSchedulingRecommendations('TCH001');
```

### Real-time Collaboration
```dart
// Get instance
final collab = Get.find<RealtimeCollaborationService>();

// Join meeting
await collab.joinMeeting('MEET001', 'STU001', 'Kathirvel', 'participant');

// Send chat message
await collab.sendChatMessage('STU001', 'Kathirvel', 'Hello!');

// Draw on whiteboard
await collab.drawOnWhiteboard('STU001', strokeData);

// Create poll
await collab.createPoll(
  'What topic next?',
  ['Algebra', 'Geometry', 'Calculus'],
  'TCH001',
  'Prof. Kumar',
);

// Raise hand
await collab.raiseHand('STU001', 'Kathirvel');

// Send reaction
await collab.sendReaction('STU001', 'Kathirvel', '👍');

// Leave meeting
await collab.leaveMeeting('STU001');
```

---

## 🗄️ Database Tables

```sql
-- Users
users (id, name, email, role, phone, department, subjects, class_name, roll_number)

-- Online Classes
online_classes (id, title, subject, teacher_id, scheduled_time, duration, meeting_link, status, max_students, class_code)

-- Enrollments
class_enrollments (id, class_id, student_id, enrolled_at)

-- Assessments
assessments (id, title, subject, teacher_id, due_date, total_marks, questions)

-- Submissions
assessment_submissions (id, assessment_id, student_id, answers, score, submitted_at)

-- Notifications
notifications (id, title, message, category, recipient_ids, action_id, created_at)

-- Translations
translations (id, user_id, source_text, target_text, source_language, target_language, created_at)

-- Chat
chat_messages (id, meeting_id, sender_id, sender_name, message, created_at)

-- Participants
meeting_participants (id, meeting_id, user_id, user_name, role, joined_at, left_at)
```

---

## ⏰ Automatic Cleanup

### How It Works
- Runs every hour automatically
- Deletes data older than 2 days
- Cleans: completed classes, cancelled classes, notifications, chat, translations

### Manual Trigger
```dart
await Get.find<DatabaseService>().manualCleanup();
```

### SQL Function
```sql
SELECT cleanup_old_data();
```

---

## 📊 Analytics Queries

### Student Performance
```dart
final analytics = await AdvancedAnalyticsService().getStudentAnalytics('STU001');
// Returns: totalAssessments, averageScore, attendanceRate, subjectPerformance
```

### Performance Trends
```dart
final trends = await AdvancedAnalyticsService().getPerformanceTrends('STU001', 30);
// Returns: 30-day performance history
```

### Attendance Report
```dart
final report = await AdvancedAnalyticsService().getAttendanceReport('CLASS001');
// Returns: totalEnrolled, totalAttended, attendanceRate, attendedStudents, absentStudents
```

---

## 🤖 AI Recommendations

### Priority Levels
- **High**: Weak subjects (score < 60%)
- **Medium**: Interested subjects
- **Low**: Popular classes

### Recommendation Types
- **Urgent**: Score < 50%
- **Warning**: Declining performance
- **Improvement**: Score 50-70%

### Learning Levels
- **Beginner**: < 60% average
- **Intermediate**: 60-80% average
- **Advanced**: > 80% average

---

## 🔴 Real-time Events

### Broadcast Events
- `chat` - Chat messages
- `whiteboard` - Whiteboard strokes
- `poll` - Poll creation/voting
- `hand_raise` - Hand raise notifications
- `screen_share` - Screen sharing status
- `reaction` - Emoji reactions
- `mute_control` - Mute/unmute
- `class_end` - Class ended

### Presence Tracking
```dart
channel.track({
  'user_id': userId,
  'user_name': userName,
  'role': role,
  'joined_at': DateTime.now().toIso8601String(),
});
```

---

## 🎨 UI Components

### Color Scheme
- **Admin**: Red/Orange (#FF6B6B → #FFE66D)
- **Staff**: Cyan (#00BCD4 → #4DD0E1)
- **Student**: Teal (#4ECDC4 → #44A08D)

### Status Colors
- 🔴 **Live**: Red
- 🟡 **Starting Soon**: Orange
- 🟢 **Completed**: Green
- 🔵 **Scheduled**: Blue

---

## 🔧 Configuration

### Supabase Config
```dart
// lib/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_URL';
  static const String supabaseAnonKey = 'YOUR_KEY';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
```

### Environment Variables
```bash
# .env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-key
```

---

## 🐛 Debugging

### Enable Logging
```dart
// In database_service.dart
print('✅ Operation successful');
print('❌ Error: $e');
```

### Check Cleanup
```dart
// View cleanup logs
// Look for: "Automatic cleanup completed"
```

### Test Real-time
```dart
// Join meeting and check console
await collab.joinMeeting(...);
// Should see: "✅ Joined meeting: MEET001"
```

---

## 📱 Build Commands

```bash
# Development
flutter run

# Release (Android)
flutter build apk --release
flutter build appbundle --release

# Release (iOS)
flutter build ios --release
flutter build ipa --release

# Release (Web)
flutter build web --release

# Desktop
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

---

## 🔗 Useful Links

- **Supabase Dashboard**: https://app.supabase.com
- **Flutter Docs**: https://flutter.dev/docs
- **GetX Docs**: https://github.com/jonataslaw/getx
- **Supabase Docs**: https://supabase.com/docs

---

## 🆘 Common Issues

### Issue: Cleanup not running
**Solution**: Check Timer initialization in `database_service.dart`

### Issue: Real-time not working
**Solution**: Verify Supabase URL and keys in config

### Issue: Analytics returning empty
**Solution**: Ensure data exists in database tables

### Issue: Build errors
**Solution**: Run `flutter clean && flutter pub get`

---

## 📞 Support

- **Email**: support@jeduai.com
- **Docs**: See `docs/` folder
- **Issues**: GitHub Issues

---

**Quick Reference v2.0.0**
*Last Updated: December 2024*
