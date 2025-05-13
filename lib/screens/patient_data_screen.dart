// This file will be where you upload the patient data used for the AI generated prompt
// No patient data will be used in the AI
import 'package:flutter/material.dart';
// Add this for future? Or remove if getting all data from db
// import 'prompt_screen.dart';

class PatientDataScreen extends StatelessWidget {
  static const routeName = '/patient-data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Patient Data'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/prompt'),
                  child: const Text('Go to Prompt'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
