import 'package:flutter/material.dart';

// your existing screens
import 'screens/home_screen.dart';
import 'screens/patient_data_screen.dart';
import 'screens/prompt_screen.dart';
import 'screens/result_screen.dart';
// new sit-to-stand screen
import 'screens/sit_to_stand_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key})
    : super(key: key); // you can drop `const` here if you prefer

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
        SitToStandScreen.routeName: (_) => SitToStandScreen(),
      },
    );
  }
}
