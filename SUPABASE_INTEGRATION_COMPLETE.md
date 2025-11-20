# 🚀 JeduAI - Complete Supabase Integration with Auto-Cleanup

## ✅ What's Implemented

### 1. **Full Supabase Database Integration**

#### Database Service (`lib/services/database_service.dart`)
- ✅ Complete CRUD operations for all entities
- ✅ Real-time subscriptions
- ✅ Automatic data cleanup (2-day retention)
- ✅ Error handling and logging
- ✅ Transaction support

#### Features:
- **User Management**: Authentication, profiles, role-based access
- **Online Classes**: Create, schedule, join, monitor
- **Assessments**: Create, submit, grade
- **Notifications**: Real-time cross-portal notifications
- **Translations**: Save and retrieve translation history
- **Chat**: Store and retrieve meeting chat messages

---

### 2. **Automatic Data Cleanup System** ⏰

#### Client-Side Cleanup (Flutter App)
**File**: `lib/services/database_service.dart`

```dart
// Runs every hour automatically
void _startAutomaticCleanup() {
  Timer.periodic(const Duration(hours: 1), (timer) {
    _cleanupOldData();
  });
}
```

**What Gets Deleted After 2 Days:**
- ✅ Completed online classes
- ✅ Cancelled online classes
- ✅ Old notifications
- ✅ Old chat messages
- ✅ Old translation history

#### Server-Side Cleanup (Supabase)
**File**: `database/setup.sql`

**PostgreSQL Function:**
```sql
CREATE OR REPLACE FUNCTION cleanup_old_data()
RETURNS void AS $$
DECLARE
    two_days_ago TIMESTAMP WITH TIME ZONE;
BEGIN
    two_days_ago := NOW() - INTERVAL '2 days';
    
    -- Delete old completed classes
    DELETE FROM online_classes 
    WHERE status = 'completed' 
    AND scheduled_time < two_days_ago;
    
    -- Delete old cancelled classes
    DELETE FROM online_classes 
    WHERE status = 'cancelled' 
    AND created_at < two_days_ago;
    
    -- Delete old notifications, chat, translations
    -- ... (see setup.sql for complete code)
END;
$$ LANGUAGE plpgsql;
```

**Three Ways to Run Cleanup:**

1. **Automatic (Client-Side)**: Runs every hour in the Flutter app
2. **Cron Job (Server-Side)**: Using pg_cron extension
3. **Edge Function (Server-Side)**: Using Supabase Edge Functions

---

### 3. **Database Schema**

#### Core Tables

**users**
```sql
- id (TEXT, PRIMARY KEY)
- name, email, role
- phone, department
- subjects (TEXT[]) -- for staff
- class_name, roll_number -- for students
- created_at, updated_at
```

**online_classes**
```sql
- id (TEXT, PRIMARY KEY)
- title, subject
- teacher_id, teacher_name
- scheduled_time, duration
- meeting_link, meeting_id
- status (scheduled/live/completed/cancelled)
- description, max_students
- class_code
- created_at, updated_at
```

**class_enrollments**
```sql
- id (TEXT, PRIMARY KEY)
- class_id (FK → online_classes)
- student_id (FK → users)
- enrolled_at
```

**assessments**
```sql
- id (TEXT, PRIMARY KEY)
- title, subject
- teacher_id (FK → users)
- description, due_date
- total_marks
- questions (JSONB)
- created_at, updated_at
```

**notifications**
```sql
- id (TEXT, PRIMARY KEY)
- title, message
- category
- recipient_ids (TEXT[])
- action_id
- created_at
```

**translations**
```sql
- id (TEXT, PRIMARY KEY)
- user_id (FK → users)
- source_text, target_text
- source_language, target_language
- created_at
```

**chat_messages**
```sql
- id (TEXT, PRIMARY KEY)
- meeting_id
- sender_id (FK → users)
- sender_name, message
- created_at
```

---

### 4. **Advanced Features**

#### Real-Time Subscriptions
```dart
// Subscribe to class updates
Stream<List<Map<String, dynamic>>> subscribeToClasses() {
  return _client
      .from(DatabaseTables.onlineClasses)
      .stream(primaryKey: ['id'])
      .order('scheduled_time');
}

// Subscribe to notifications
Stream<List<Map<String, dynamic>>> subscribeToNotifications(String userId) {
  return _client
      .from(DatabaseTables.notifications)
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);
}
```

#### Row Level Security (RLS)
- ✅ Enabled on all tables
- ✅ Policies for read/write access
- ✅ Role-based permissions
- ✅ Secure by default

#### Performance Optimizations
- ✅ Indexes on frequently queried columns
- ✅ Composite indexes for complex queries
- ✅ GIN indexes for array columns
- ✅ Automatic timestamp updates

---

### 5. **Setup Instructions**

#### Step 1: Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Wait for initialization (2-3 minutes)

#### Step 2: Run SQL Setup
1. Open Supabase Dashboard → SQL Editor
2. Copy contents from `database/setup.sql`
3. Click **Run**
4. Verify tables are created

#### Step 3: Get API Keys
1. Go to Settings → API
2. Copy:
   - Project URL
   - Anon/Public Key
   - Service Role Key (keep secret!)

#### Step 4: Update Flutter Config
Edit `lib/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
```

#### Step 5: Run the App
```bash
flutter pub get
flutter run
```

---

### 6. **Automatic Cleanup Configuration**

#### Option A: Client-Side (Default - Already Implemented)
- ✅ Runs automatically when app starts
- ✅ Executes every hour
- ✅ No additional setup needed
- ⚠️ Requires app to be running

#### Option B: Server-Side with pg_cron
1. Enable pg_cron extension in Supabase
2. Uncomment this line in `setup.sql`:
```sql
SELECT cron.schedule('cleanup-old-data', '0 * * * *', 'SELECT cleanup_old_data()');
```
3. Cleanup runs every hour automatically
4. ✅ Works even when app is closed

#### Option C: Supabase Edge Function
1. Create Edge Function:
```bash
supabase functions new cleanup-old-data
```

2. Add function code:
```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  )

  const { data, error } = await supabase.rpc('handle_cleanup_old_data')

  return new Response(JSON.stringify(data || error), {
    headers: { 'Content-Type': 'application/json' },
  })
})
```

3. Deploy:
```bash
supabase functions deploy cleanup-old-data
```

4. Schedule with GitHub Actions or external cron

---

### 7. **Testing the System**

#### Test Automatic Cleanup
```dart
// Manual trigger (for testing)
await Get.find<DatabaseService>().manualCleanup();
```

#### Test Database Operations
```dart
// Create a class
final classId = await DatabaseService().createOnlineClass(
  title: 'Test Class',
  subject: 'Mathematics',
  teacherId: 'STF001',
  teacherName: 'Teacher Name',
  scheduledTime: DateTime.now().add(Duration(hours: 2)),
  duration: 60,
  description: 'Test description',
  maxStudents: 50,
  meetingLink: 'https://meet.jeduai.com/test',
  classCode: 'TEST-123',
);

// Enroll student
await DatabaseService().enrollInClass(classId, 'STU001');

// Get all classes
final classes = await DatabaseService().getAllOnlineClasses();
```

---

### 8. **Monitoring & Logs**

#### Client-Side Logs
```
✅ Supabase initialized successfully
✅ Database initialized with automatic cleanup enabled
✅ Automatic cleanup completed successfully
   - Completed classes deleted
   - Cancelled classes deleted
   - Old notifications deleted
   - Old chat messages deleted
   - Old translations deleted
```

#### Server-Side Logs (Supabase Dashboard)
- Go to Database → Logs
- Filter by function: `cleanup_old_data`
- View execution history and results

---

### 9. **Security Features**

#### Row Level Security (RLS)
```sql
-- Example: Students can only see their own data
CREATE POLICY "Students see own data" ON users
    FOR SELECT
    USING (auth.uid()::text = id AND role = 'student');

-- Example: Teachers can manage their own classes
CREATE POLICY "Teachers manage own classes" ON online_classes
    FOR ALL
    USING (teacher_id = auth.uid()::text);
```

#### API Key Security
- ✅ Anon key for client-side operatio