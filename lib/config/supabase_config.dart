import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Configuration
class SupabaseConfig {
  // Replace with your actual Supabase URL and Anon Key
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // Set to false in production
    );
  }

  /// Get Supabase client
  static SupabaseClient get client => Supabase.instance.client;
}

/// Database Tables
class DatabaseTables {
  static const String users = 'users';
  static const String onlineClasses = 'online_classes';
  static const String classEnrollments = 'class_enrollments';
  static const String assessments = 'assessments';
  static const String assessmentSubmissions = 'assessment_submissions';
  static const String notifications = 'notifications';
  static const String translations = 'translations';
  static const String chatMessages = 'chat_messages';
  static const String meetingParticipants = 'meeting_participants';
}
