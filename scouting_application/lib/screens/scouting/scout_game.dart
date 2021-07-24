import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_autonomous.dart';
import 'package:scouting_application/screens/scouting/scout_endgame.dart';
import 'package:scouting_application/screens/scouting/scout_submission.dart';
import 'package:scouting_application/screens/scouting/scout_teleoperated.dart';

class ScoutGame extends StatefulWidget {
  ScoutGame({Key? key, required this.matchNumber, required this.teamNumber})
      : super(key: key);
  ScoutAutonomous autonomous = new ScoutAutonomous();
  ScoutTeleoperated teleoperated = new ScoutTeleoperated();
  ScoutEndgame endgame = new ScoutEndgame();
  ScoutSubmission submission = new ScoutSubmission();
  final int matchNumber;
  final int teamNumber;

  @override
  _ScoutGameState createState() => _ScoutGameState();
}

class _ScoutGameState extends State<ScoutGame> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                  'match: #${widget.matchNumber} | team: #${widget.teamNumber}'),
              automaticallyImplyLeading: false,
              bottom: TabBar(
                indicatorColor: Color.fromARGB(255, 50, 50, 35),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                tabs: [
                  Tab(text: "אוטונומי", icon: Icon(Icons.do_not_touch)),
                  Tab(text: "Teleop", icon: Icon(Icons.drive_eta_rounded)),
                  Tab(text: "Endgame", icon: Icon(Icons.elevator)),
                  Tab(
                    text: 'Playstyle',
                    icon: Icon(Icons.alt_route),
                  )
                ],
              ),
            ),
            body: TabBarView(children: [
              widget.autonomous,
              widget.teleoperated,
              widget.endgame,
              widget.submission
            ])),
      ),
    );
  }
}
