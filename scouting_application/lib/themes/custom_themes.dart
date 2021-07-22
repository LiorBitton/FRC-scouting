import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isLightMode => themeMode == ThemeMode.light;
}

class CustomTheme {
  static ThemeData get darkTheme {
    return ThemeData(
        colorScheme: ColorScheme.dark(),
        dividerColor: Colors.white,
        primaryColor: Color.fromRGBO(18, 18, 18, 1),
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Montserrat',
        textTheme: ThemeData.dark().textTheme,
        iconTheme: IconThemeData(color: Colors.white70, opacity: 100),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(width: 20)),
          buttonColor: Colors.greenAccent,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          backgroundColor: Colors.greenAccent,
        ));
  }

  static ThemeData get lightTheme {
    //1
    
    return ThemeData(
        colorScheme: ColorScheme.light(),
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        ));
  }
}
