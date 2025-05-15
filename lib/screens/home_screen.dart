// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  final _geminiService = const GeminiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Stroke Action Planner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          () => Navigator.pushNamed(context, '/patient-data'),
                      child: const Text('Upload Patient Data'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/prompt'),
                      child: const Text('Go to Prompt'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/result'),
                      child: const Text('View Result'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder<String>(
                    // this calls the encouragement message that we made in gemini_service.dart
                    future: _geminiService.getEncouragingMessage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading encouragement...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Stay positive, you’re making great progress!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Text(
                          snapshot.data ?? 'Have a wonderful day!',
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                    },
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
