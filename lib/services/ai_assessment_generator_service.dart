import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/gemini_config.dart';

class AIAssessmentGeneratorService {
  static final AIAssessmentGeneratorService _instance =
      AIAssessmentGeneratorService._internal();
  factory AIAssessmentGeneratorService() => _instance;
  AIAssessmentGeneratorService._internal();

  Future<Map<String, dynamic>> generateAssessment({
    required String subject,
    required String classLevel,
    required String type,
    required String difficulty,
    required int numberOfQuestions,
    required int duration,
    required bool includeAnswers,
  }) async {
    try {
      final prompt = _buildPrompt(
        subject: subject,
        classLevel: classLevel,
        type: type,
        difficulty: difficulty,
        numberOfQuestions: numberOfQuestions,
        includeAnswers: includeAnswers,
      );

      final response = await http.post(
        Uri.parse(
          '${GeminiConfig.baseUrl}/models/${GeminiConfig.modelName}:generateContent?key=${GeminiConfig.apiKey}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 8192,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Gemini API Response received');

        try {
          final generatedText =
              data['candidates'][0]['content']['parts'][0]['text'];
          print('📝 Generated text length: ${generatedText.length}');

          return _parseGeneratedAssessment(
            generatedText,
            subject,
            classLevel,
            type,
            difficulty,
            numberOfQuestions,
            duration,
          );
        } catch (parseError) {
          print('❌ Error parsing response: $parseError');
          print('Response data: $data');
          throw parseError;
        }
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
          'Failed to generate assessment: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error generating assessment: $e');
      print('Stack trace: ${StackTrace.current}');
      // Return a fallback assessment
      return _generateFallbackAssessment(
        subject,
        classLevel,
        type,
        difficulty,
        numberOfQuestions,
        duration,
      );
    }
  }

  String _buildPrompt({
    required String subject,
    required String classLevel,
    required String type,
    required String difficulty,
    required int numberOfQuestions,
    required bool includeAnswers,
  }) {
    return '''
You are an expert educator creating a $difficulty level $type assessment for $classLevel students.

Subject: $subject
Number of Questions: $numberOfQuestions
Difficulty Level: $difficulty
Class Level: $classLevel

IMPORTANT: Respond ONLY with a valid JSON array. Do not include any explanatory text before or after the JSON.

Create exactly $numberOfQuestions multiple-choice questions following this EXACT JSON format:

[
  {
    "id": "1",
    "question": "What is the primary purpose of data normalization in databases?",
    "options": [
      "To increase data redundancy",
      "To reduce data redundancy and improve data integrity",
      "To make queries slower",
      "To increase storage space"
    ],
    "correctAnswer": 1,
    "explanation": "Data normalization reduces redundancy and improves data integrity by organizing data efficiently."
  }
]

Requirements for each question:
1. "id": Sequential number as string ("1", "2", "3"...)
2. "question": Clear, specific question text appropriate for $classLevel
3. "options": Array of exactly 4 answer choices
4. "correctAnswer": Index (0-3) of the correct option
5. "explanation": Brief explanation of why the answer is correct

Question Guidelines:
- Make questions relevant to $subject
- Ensure $difficulty difficulty level
- Cover different topics within the subject
- Make all options plausible
- Avoid ambiguous wording
- Use proper grammar and spelling

Generate ONLY the JSON array now (no other text):
''';
  }

  Map<String, dynamic> _parseGeneratedAssessment(
    String generatedText,
    String subject,
    String classLevel,
    String type,
    String difficulty,
    int numberOfQuestions,
    int duration,
  ) {
    try {
      // Extract JSON from the response
      final jsonStart = generatedText.indexOf('[');
      final jsonEnd = generatedText.lastIndexOf(']') + 1;

      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonString = generatedText.substring(jsonStart, jsonEnd);
        final questions = jsonDecode(jsonString) as List;

        return {
          'success': true,
          'assessment': {
            'title': '$subject $type - $classLevel',
            'subject': subject,
            'classLevel': classLevel,
            'type': type,
            'difficulty': difficulty,
            'totalQuestions': questions.length,
            'duration': duration,
            'questions': questions,
            'generatedAt': DateTime.now().toIso8601String(),
          },
        };
      } else {
        throw Exception('No valid JSON found in response');
      }
    } catch (e) {
      print('Error parsing assessment: $e');
      return _generateFallbackAssessment(
        subject,
        classLevel,
        type,
        difficulty,
        numberOfQuestions,
        duration,
      );
    }
  }

  Map<String, dynamic> _generateFallbackAssessment(
    String subject,
    String classLevel,
    String type,
    String difficulty,
    int numberOfQuestions,
    int duration,
  ) {
    final questions = List.generate(
      numberOfQuestions,
      (index) => {
        'question':
            'Sample question ${index + 1} for $subject ($difficulty level)',
        'options': ['Option A', 'Option B', 'Option C', 'Option D'],
        'correctAnswer': 0,
        'explanation':
            'This is a sample question. The AI-generated version will have real content.',
      },
    );

    return {
      'success': true,
      'assessment': {
        'title': '$subject $type - $classLevel',
        'subject': subject,
        'classLevel': classLevel,
        'type': type,
        'difficulty': difficulty,
        'totalQuestions': numberOfQuestions,
        'duration': duration,
        'questions': questions,
        'generatedAt': DateTime.now().toIso8601String(),
        'isFallback': true,
      },
    };
  }

  // Quick generation for common subjects
  Future<Map<String, dynamic>> generateQuickAssessment(String subject) async {
    return generateAssessment(
      subject: subject,
      classLevel: 'Class 10',
      type: 'Quiz',
      difficulty: 'Medium',
      numberOfQuestions: 10,
      duration: 15,
      includeAnswers: true,
    );
  }
}
