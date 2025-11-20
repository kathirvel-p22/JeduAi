-- JeduAI Database Setup for Supabase with Automatic Cleanup
-- Run these commands in your Supabase SQL editor

-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('admin', 'staff', 'student')),
    phone TEXT,
    department TEXT,
    subjects TEXT[], -- For staff
    class_name TEXT, -- For students
    roll_number TEXT, -- For students
    profile_image TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Online Classes table
CREATE TABLE IF NOT EXISTS online_classes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    subject TEXT NOT NULL,
    teacher_id TEXT NOT NULL REFERENCES users(id),
    teacher_name TEXT NOT NULL,
    scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
    duration INTEGER NOT NULL, -- in minutes
    meeting_link TEXT NOT NULL,
    meeting_id TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'live', 'completed', 'cancelled')),
    description TEXT,
    max_students INTEGER DEFAULT 50,
    class_code TEXT NOT NULL,
    recording_link TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Class Enrollments table
CREATE TABLE IF NOT EXISTS class_enrollments (
    id TEXT PRIMARY KEY,
    class_id TEXT NOT NULL REFERENCES online_classes(id) ON DELETE CASCADE,
    student_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(class_id, student_id)
);

-- Assessments table
CREATE TABLE IF NOT EXISTS assessments (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    subject TEXT NOT NULL,
    teacher_id TEXT NOT NULL REFERENCES users(id),
    description TEXT,
    due_date TIMESTAMP WITH TIME ZONE NOT NULL,
    total_marks INTEGER NOT NULL,
    questions JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Assessment Submissions table
CREATE TABLE IF NOT EXISTS assessment_submissions (
    id TEXT PRIMARY KEY,
    assessment_id TEXT NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
    student_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    answers JSONB NOT NULL,
    score INTEGER,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(assessment_id, student_id)
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('classScheduled', 'classStarted', 'classCancelled', 'assessmentCreated', 'assessmentDue', 'announcement', 'reminder', 'system')),
    recipient_ids TEXT[] NOT NULL,
    action_id TEXT, -- ID of related item (class, assessment, etc.)
    data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Translations table
CREATE TABLE IF NOT EXISTS translations (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id),
    source_text TEXT NOT NULL,
    target_text TEXT NOT NULL,
    source_language TEXT NOT NULL,
    target_language TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Chat Messages table
CREATE TABLE IF NOT EXISTS chat_messages (
    id TEXT PRIMARY KEY,
    meeting_id TEXT NOT NULL,
    sender_id TEXT NOT NULL REFERENCES users(id),
    sender_name TEXT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Meeting Participants table
CREATE TABLE IF NOT EXISTS meeting_participants (
    id TEXT PRIMARY KEY,
    meeting_id TEXT NOT NULL,
    user_id TEXT NOT NULL REFERENCES users(id),
    user_name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('host', 'coHost', 'participant')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    left_at TIMESTAMP WITH TIME ZONE,
    duration_minutes INTEGER
);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_online_classes_teacher ON online_classes(teacher_id);
CREATE INDEX IF NOT EXISTS idx_online_classes_status ON online_classes(status);
CREATE INDEX IF NOT EXISTS idx_online_classes_scheduled_time ON online_classes(scheduled_time);
CREATE INDEX IF NOT EXISTS idx_online_classes_created_at ON online_classes(created_at);
CREATE INDEX IF NOT EXISTS idx_class_enrollments_student ON class_enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_class_enrollments_class ON class_enrollments(class_id);
CREATE INDEX IF NOT EXISTS idx_assessments_teacher ON assessments(teacher_id);
CREATE INDEX IF NOT EXISTS idx_assessments_due_date ON assessments(due_date);
CREATE INDEX IF NOT EXISTS idx_notifications_recipients ON notifications USING GIN(recipient_ids);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_translations_user ON translations(user_id);
CREATE INDEX IF NOT EXISTS idx_translations_created_at ON translations(created_at);
CREATE INDEX IF NOT EXISTS idx_chat_messages_meeting ON chat_messages(meeting_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at ON chat_messages(created_at);

-- Row Level Security Policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE online_classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE class_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE translations ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_participants ENABLE ROW LEVEL SECURITY;

-- Basic RLS policies (customize based on your needs)
-- Users can read their own data
CREATE POLICY "Users can read own data" ON users
    FOR SELECT USING (true); -- Allow all for now, customize later

-- Online classes are readable by all authenticated users
CREATE POLICY "Classes readable by all" ON online_classes
    FOR SELECT USING (true);

-- Teachers can create and update their own classes
CREATE POLICY "Teachers can manage own classes" ON online_classes
    FOR ALL USING (true); -- Simplify for now

-- Students can enroll in classes
CREATE POLICY "Students can enroll" ON class_enrollments
    FOR ALL USING (true);

-- Basic policies for other tables
CREATE POLICY "Allow all operations" ON assessments FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON assessment_submissions FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON notifications FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON translations FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON chat_messages FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON meeting_participants FOR ALL USING (true);

-- Functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for automatic timestamp updates
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_online_classes_updated_at BEFORE UPDATE ON online_classes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assessments_updated_at BEFORE UPDATE ON assessments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- AUTOMATIC DATA CLEANUP (2 DAYS RETENTION)
-- ============================================

-- Function for automatic data cleanup (older than 2 days)
CREATE OR REPLACE FUNCTION cleanup_old_data()
RETURNS void AS $$
DECLARE
    two_days_ago TIMESTAMP WITH TIME ZONE;
    deleted_count INTEGER;
BEGIN
    two_days_ago := NOW() - INTERVAL '2 days';
    
    RAISE NOTICE 'Starting automatic cleanup for data older than %', two_days_ago;
    
    -- Delete old completed classes
    DELETE FROM online_classes 
    WHERE status = 'completed' 
    AND scheduled_time < two_days_ago;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE '✅ Deleted % completed classes', deleted_count;
    
    -- Delete old cancelled classes
    DELETE FROM online_classes 
    WHERE status = 'cancelled' 
    AND created_at < two_days_ago;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE '✅ Deleted % cancelled classes', deleted_count;
    
    -- Delete old notifications
    DELETE FROM notifications 
    WHERE created_at < two_days_ago;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE '✅ Deleted % old notifications', deleted_count;
    
    -- Delete old chat messages
    DELETE FROM chat_messages 
    WHERE created_at < two_days_ago;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE '✅ Deleted % old chat messages', deleted_count;
    
    -- Delete old translation history
    DELETE FROM translations 
    WHERE created_at < two_days_ago;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE '✅ Deleted % old translations', deleted_count;
    
    RAISE NOTICE '✅ Automatic cleanup completed successfully';
END;
$$ LANGUAGE plpgsql;

-- Create a function that can be called via Edge Function or cron job
CREATE OR REPLACE FUNCTION public.handle_cleanup_old_data()
RETURNS json AS $$
DECLARE
    result json;
BEGIN
    PERFORM cleanup_old_data();
    result := json_build_object(
        'success', true,
        'message', 'Cleanup completed successfully',
        'timestamp', NOW()
    );
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- SETUP CRON JOB (Optional - requires pg_cron extension)
-- ============================================
-- Uncomment the following line if pg_cron is enabled in your Supabase project
-- This will run cleanup every hour
-- SELECT cron.schedule('cleanup-old-data', '0 * * * *', 'SELECT cleanup_old_data()');

-- ============================================
-- ALTERNATIVE: Supabase Edge Function
-- ============================================
-- Create a Supabase Edge Function that calls handle_cleanup_old_data()
-- Schedule it using GitHub Actions or external cron service
-- Example Edge Function code:
/*
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  )

  const { data, error } = await supabase.rpc('handle_cleanup_old_data')

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    })
  }

  return new Response(JSON.stringify(data), {
    headers: { 'Content-Type': 'application/json' },
  })
})
*/

-- Insert sample data
INSERT INTO users (id, name, email, role, phone, department, created_at) VALUES
('USR001', 'Kathirvel P', 'mpkathir@gmail.com', 'admin', '+91 9876543210', 'Administration', NOW()),
('STF001', 'Kathirvel P', 'kathirvel.staff@jeduai.com', 'staff', '+91 9876543210', 'Computer Science', NOW()),
('STU001', 'Kathirvel P', 'kathirvel.student@jeduai.com', 'student', '+91 9876543210', 'Computer Science', NOW()),
('STU002', 'Priya Sharma', 'student2@jeduai.com', 'student', NULL, 'Computer Science', NOW()),
('STF002', 'Dr. Rajesh Kumar', 'teacher1@jeduai.com', 'staff', NULL, 'Mathematics', NOW())
ON CONFLICT (email) DO NOTHING;

-- Update staff subjects
UPDATE users SET subjects = ARRAY['Artificial Intelligence', 'Data Structures', 'Algorithms'] WHERE id = 'STF001';
UPDATE users SET subjects = ARRAY['Calculus', 'Algebra', 'Statistics'] WHERE id = 'STF002';

-- Update student details
UPDATE users SET class_name = 'Class 12', roll_number = 'CS12001' WHERE id = 'STU001';
UPDATE users SET class_name = 'Class 12', roll_number = 'CS12002' WHERE id = 'STU002';

-- Test the cleanup function (optional)
-- SELECT cleanup_old_data();

COMMIT;

-- ============================================
-- SETUP COMPLETE
-- ============================================
-- ✅ All tables created
-- ✅ Indexes created for performance
-- ✅ Row Level Security enabled
-- ✅ Automatic cleanup function created
-- ✅ Sample data inserted
-- 
-- NEXT STEPS:
-- 1. Update lib/config/supabase_config.dart with your Supabase URL and keys
-- 2. (Optional) Enable pg_cron extension and uncomment the cron.schedule line
-- 3. (Optional) Create Supabase Edge Function for cleanup
-- 4. Run the app and test!
