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
        primaryColor: teamColor,
        scaffoldBackgroundColor: darkTeamColor,
        appBarTheme: AppBarTheme(
          color: teamColor,
          titleTextStyle: GoogleFonts.acme(fontSize: 25),
        ),
        iconTheme: IconThemeData(color: teamColor),
        progressIndicatorTheme: ProgressIndicatorThemeData(
            linearTrackColor: darkTeamColor, color: lightTeamColor),
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

  static const Color teamColor = Color.fromRGBO(107, 181, 46, 100);
  static const Color lightTeamColor = Color.fromARGB(255, 199, 233, 171);
  static const Color darkTeamColor = Color.fromARGB(200, 84, 136, 68);
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(),
        primaryColor: teamColor,
        scaffoldBackgroundColor: lightTeamColor,
        appBarTheme: AppBarTheme(
            color: teamColor, titleTextStyle: GoogleFonts.acme(fontSize: 25)),
        iconTheme: IconThemeData(color: teamColor),
        progressIndicatorTheme: ProgressIndicatorThemeData(
            linearTrackColor: darkTeamColor, color: lightTeamColor),
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        ));
  }
}
