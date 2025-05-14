// lib/services/gemini_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  /// URL of your local backend proxy
  static const _proxyUrl = 'http://localhost:3000/generate-content';

  final String apiKey; // no longer used for auth, but you can remove if unused

  GeminiService(this.apiKey);

  /// Sends [prompt] to your Express proxy, which in turn calls Gemini Flash-Lite.
  /// Returns the generated text from the first candidate’s parts[0].text.
  Future<String> generateContent(String prompt) async {
    final response = await http.post(
      Uri.parse(_proxyUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to generate content: ${response.statusCode} ${response.body}',
      );
    }

    // Decode the JSON response into a Map
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    // Extract the 'candidates' array
    final List<dynamic>? candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No candidates returned from Gemini');
    }

    // Take the first candidate’s content map
    final Map<String, dynamic>? content =
        (candidates[0] as Map<String, dynamic>)['content']
            as Map<String, dynamic>?;
    if (content == null) {
      throw Exception('Missing content in Gemini response');
    }

    // Extract the 'parts' array inside content
    final List<dynamic>? parts = content['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw Exception('No content parts returned from Gemini');
    }

    // Finally, extract the 'text' string from the first part
    final String? text = (parts[0] as Map<String, dynamic>)['text'] as String?;
    if (text == null) {
      throw Exception('Missing text in Gemini response');
    }

    return text;
  }
}
