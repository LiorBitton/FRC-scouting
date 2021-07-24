import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_pregame.dart';
import 'package:scouting_application/screens/scouting/scout_game.dart';

class ScoutSubmission extends StatefulWidget {
  ScoutSubmission({Key? key}) : super(key: key);

  @override
  _ScoutSubmissionState createState() => _ScoutSubmissionState();
}

class _ScoutSubmissionState extends State<ScoutSubmission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'comment'),
        )
      ],
    ));
  }
}
