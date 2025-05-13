import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;

  GeminiService(this.apiKey);

  Future<String> generateContent(String prompt) async {
    const String url =
        'https://genai.googleapis.com/v1/models/gemini-2.0-flash:generateContent';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'model': 'gemini-2.0-flash', 'contents': prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['text']; // Adjust this based on the actual API response structure
    } else {
      throw Exception('Failed to generate content: ${response.body}');
    }
  }
}
