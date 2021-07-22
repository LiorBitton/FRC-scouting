import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLightTheme = ThemeProvider().isLightMode;
  Color _textColor = Colors.black;
  Color _appBarColor = Color.fromRGBO(36, 41, 46, 1);
  Color _scaffoldBgcolor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSwitch(
        width: 100.0,
        height: 55.0,
        toggleSize: 45.0,
        value: isLightTheme,
        borderRadius: 30.0,
        padding: 2.0,
        activeToggleColor: Color(0xFF6E40C9),
        inactiveToggleColor: Color(0xFF2F363D),
        activeSwitchBorder: Border.all(
          color: Color(0xFF3C1E70),
          width: 6.0,
        ),
        inactiveSwitchBorder: Border.all(
          color: Color(0xFFD1D5DA),
          width: 6.0,
        ),
        activeColor: Color(0xFF271052),
        inactiveColor: Colors.white,
        activeIcon: Icon(
          Icons.nightlight_round,
          color: Color(0xFFF8E3A1),
        ),
        inactiveIcon: Icon(
          Icons.wb_sunny,
          color: Color(0xFFFFDF5D),
        ),
        onToggle: (val) {
          setState(() {
            isLightTheme = val;

            if (val) {
              _textColor = Colors.white;
              _appBarColor = Color.fromRGBO(22, 27, 34, 1);
              _scaffoldBgcolor = Color(0xFF0D1117);
            } else {
              _textColor = Colors.black;
              _appBarColor = Color.fromRGBO(36, 41, 46, 1);
              _scaffoldBgcolor = Colors.white;
            }
          });
        },
      ),
    );
  }
}
