import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_autonomous.dart';
import 'package:scouting_application/screens/scouting/scout_manager.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';

class ScoutHome extends StatefulWidget {
  ScoutHome({Key? key}) : super(key: key);

  @override
  _ScoutHomeState createState() => _ScoutHomeState();
}

class _ScoutHomeState extends State<ScoutHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScoutManager()));
        }),
      ],
    ));
  }
}
