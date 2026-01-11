/// Gemini API Configuration Template
///
/// INSTRUCTIONS:
/// 1. Copy this file and rename it to 'gemini_config.dart'
/// 2. Replace 'YOUR_API_KEY_HERE' with your actual Gemini API key
/// 3. Get your API key from: https://makersuite.google.com/app/apikey
///
/// SECURITY NOTE:
/// - Never commit gemini_config.dart to Git
/// - It's already in .gitignore
/// - Only share this template file
library;

class GeminiConfig {
  // Your Gemini API Key - Get it from https://makersuite.google.com/app/apikey
  static const String apiKey = 'YOUR_API_KEY_HERE';

  // API Endpoints - Using v1beta with gemini-2.5-flash
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String modelName = 'gemini-2.5-flash';
  static const String translateEndpoint = '/models/$modelName:generateContent';

  // Project Details
  static const String projectName = 'projects/334561337628';
  static const String projectNumber = '334561337628';

  // Get full API URL
  static String get translateUrl => '$baseUrl$translateEndpoint?key=$apiKey';

  // AI Tutor URL (same API key)
  static String get aiTutorUrl => '$baseUrl$translateEndpoint?key=$apiKey';
}
