/// Gemini API Configuration
class GeminiConfig {
  // Your Gemini API Key
  static const String apiKey = 'AIzaSyC49FaAvNqbGtxXuTFsNJCAytSug9NO0lA';

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
