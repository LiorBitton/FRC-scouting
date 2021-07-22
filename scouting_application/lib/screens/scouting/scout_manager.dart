import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_autonomous.dart';
import 'package:scouting_application/screens/scouting/scout_endgame.dart';
import 'package:scouting_application/screens/scouting/scout_teleoperated.dart';

class ScoutManager extends StatefulWidget {
  ScoutManager({Key? key}) : super(key: key);

  @override
  _ScoutManagerState createState() => _ScoutManagerState();
}

class _ScoutManagerState extends State<ScoutManager> {
  late Widget autonomous;
  late Widget teleoperated;
  late Widget endgame;
  @override
  Widget build(BuildContext context) {
    autonomous = new ScoutAutonomous();
    teleoperated =new  ScoutTeleoperated();
    endgame = new ScoutEndgame();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: [
                Tab(text: "אוטונומי", icon: Icon(Icons.do_not_touch)),
                Tab(text: "Teleop", icon: Icon(Icons.drive_eta_rounded)),
                Tab(text: "Endgame", icon: Icon(Icons.elevator)),
              ],
            ),
          ),
          body: TabBarView(children: [autonomous, teleoperated, endgame])),
    );
  }
}
