// lib/services/gemini_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String baseUrl = 'http://localhost:3000';
  const GeminiService();

  Future<String> generateContent(String prompt) async {
    final uri = Uri.parse('$baseUrl/generate-content');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }

    final Map<String, dynamic> data = jsonDecode(resp.body);

    // 1) Get the candidates array
    final List<dynamic>? candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No candidates in response');
    }

    // 2) First candidate’s content object
    final content =
        (candidates[0] as Map<String, dynamic>)['content']
            as Map<String, dynamic>?;
    if (content == null) {
      throw Exception('Missing content in candidate');
    }

    // 3) content.parts → array of parts
    final List<dynamic>? parts = content['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw Exception('No parts in content');
    }

    // 4) The actual text is parts[0]['text']
    final String? text = (parts[0] as Map<String, dynamic>)['text'] as String?;
    if (text == null) {
      throw Exception('Missing text in parts[0]');
    }

    return text;
  }

  // Encourage prompt, adds the current weekday to prompt, we can specify by time like morning, afternoon, evening
  /// Fetches an encouraging message tailored to the current weekday without the intro.
  Future<String> getEncouragingMessage() async {
    final dayName = _weekdayName(DateTime.now().weekday);
    final prompt =
        'Gemini: give me an encouraging message for an occupational therapist to start a $dayName morning, and respond with only the message itself (no introduction or preamble).';
    return generateContent(prompt);
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
