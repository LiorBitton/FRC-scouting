import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/screens/menu.dart';
import 'package:scouting_application/screens/sign_in_google.dart';
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
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Menu()));
      }
    });
    return MaterialApp(
      title: 'EverScout',
      themeMode: ThemeMode.system,
      theme: CustomTheme.lightTheme,
      home: GoogleSignInScreen(),
      darkTheme: CustomTheme.darkTheme,
    );
  }
}
