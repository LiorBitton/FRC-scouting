import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isLightMode => themeMode == ThemeMode.light;
}

class CustomTheme {
  static ThemeData get darkTheme {
    return ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(),
        dividerColor: Colors.white,
        primaryColor: Color.fromARGB(255, 107, 181, 46),
        scaffoldBackgroundColor: Colors.black,
        // fontFamily: ,
        textTheme: TextTheme(
            bodyText1: GoogleFonts.roboto(
                fontWeight: FontWeight.bold)), //ThemeData.dark().textTheme,
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
          backgroundColor: Color.fromARGB(255, 107, 181, 46),
        ));
  }

  static ThemeData get lightTheme {
    //1

    return ThemeData(
        brightness: Brightness.light,
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
