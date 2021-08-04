import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/screens/menu.dart';
import 'package:scouting_application/screens/scouting/scout_autonomous.dart';
import 'package:scouting_application/screens/scouting/scout_endgame.dart';
import 'package:scouting_application/screens/scouting/scout_submission.dart';
import 'package:scouting_application/screens/scouting/scout_teleoperated.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
class ScoutGame extends StatefulWidget {
  ScoutGame({Key? key})
      : super(key: key);
  static ScoutAutonomous autonomous = new ScoutAutonomous();
  static ScoutTeleoperated teleoperated = new ScoutTeleoperated();
  static ScoutEndgame endgame = new ScoutEndgame();
  static ScoutSubmission submission = new ScoutSubmission(
    onSubmit: (BuildContext context) {
      submitGame(context);
    },
  );
  static int matchNumber = 0;
  static int teamID = 0;
  static void submitGame(BuildContext context) {
    firebase_core.Firebase.initializeApp();
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    final dest = ref
        .child('teams')
        .child('$teamID')
        .child('games')
        .child('$matchNumber');
    dest.set({
      'a3': autonomous.innerButton.getCount(),
      'a2': autonomous.outerButton.getCount(),
      'a1':autonomous.lowerButton.getCount(),
      'a5': autonomous.movedSwitch.getSwitched(),
      'b3':teleoperated.innerButton.getCount(),
      'b2':teleoperated.outerButton.getCount(),
      'b1':teleoperated.lowerButton.getCount(),
      



    });
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => Menu()));
  }

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
                  'match: #${ScoutGame.matchNumber} | team: #${ScoutGame.teamID}'),
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
              ScoutGame.autonomous,
              ScoutGame.teleoperated,
              ScoutGame.endgame,
              ScoutGame.submission
            ])),
      ),
    );
  }
}
