// This screen serves as a prompt for the AI to generate a home action plan based
// on the patient's data.
import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class PromptScreen extends StatefulWidget {
  static const routeName = '/prompt';
  @override
  _PromptScreenState createState() => _PromptScreenState();
}

final GeminiService _geminiService = GeminiService(
  'AIzaSyDYn5DS21gpgHVIn2ar0VMxT65j4-AljB4',
);

class _PromptScreenState extends State<PromptScreen> {
  final _promptCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  // Method to call GeminiService and passes it to the result_screen
  void _generate() async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await _geminiService.generateContent(_promptCtrl.text);
      Navigator.pushNamed(context, '/result', arguments: response);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Enter AI Prompt'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _promptCtrl,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText:
                          'e.g. A 4-week mobility plan for a stroke patient',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _generate,
                          child: const Text('Generate Plan'),
                        ),
                      ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to Home'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
