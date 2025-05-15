// lib/screens/prompt_screen.dart

import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../services/mongo_service.dart';
import 'result_screen.dart';

class PromptScreen extends StatefulWidget {
  static const String routeName = '/prompt';
  const PromptScreen({Key? key}) : super(key: key);

  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final GeminiService _gemini = GeminiService();
  final MongoService _mongo = MongoService();
  final TextEditingController _ctrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _generateAndSave() async {
    final prompt = _ctrl.text.trim();
    if (prompt.isEmpty) return;

    setState(() => _loading = true);
    try {
      // 1. Call Gemini
      final planText = await _gemini.generateContent(prompt);

      // 2. Save into MongoDB
      final savedPlan = await _mongo.createPlan(prompt, planText);

      // 3. Navigate, passing the saved text
      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: savedPlan.plan,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext ctx) {
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
                    controller: _ctrl,
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
                          onPressed: _generateAndSave,
                          child: const Text('Generate Plan'),
                        ),
                      ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
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
