import 'package:flutter/material.dart';
import 'package:scouting_application/screens/google_sign_in.dart';
import 'package:scouting_application/themes/custom_themes.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EverScout',
      themeMode: ThemeMode.system,
      theme: CustomTheme.lightTheme,
      home: GoogleSignInScreen(),
      darkTheme: CustomTheme.darkTheme,
    );
  }
}
