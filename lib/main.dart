import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/patient_data_screen.dart';
import 'screens/prompt_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stroke Action Planner',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        PatientDataScreen.routeName: (_) => PatientDataScreen(),
        PromptScreen.routeName: (_) => PromptScreen(),
        ResultScreen.routeName: (_) => ResultScreen(),
      },
    );
  }
}
