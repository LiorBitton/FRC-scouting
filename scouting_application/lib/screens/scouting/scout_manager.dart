import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_autonomous.dart';
import 'package:scouting_application/screens/scouting/scout_endgame.dart';
import 'package:scouting_application/screens/scouting/scout_teleoperated.dart';

class ScoutManager extends StatefulWidget {
  ScoutManager({Key? key}) : super(key: key);
  ScoutAutonomous autonomous = new ScoutAutonomous();
  ScoutTeleoperated teleoperated = new ScoutTeleoperated();
  ScoutEndgame endgame = new ScoutEndgame();

  @override
  _ScoutManagerState createState() => _ScoutManagerState();
}

class _ScoutManagerState extends State<ScoutManager> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 3,

        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              bottom: TabBar(
                indicatorColor: Color.fromARGB(255, 50, 50, 35),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                tabs: [
                  Tab(text: "אוטונומי", icon: Icon(Icons.do_not_touch)),
                  Tab(text: "Teleop", icon: Icon(Icons.drive_eta_rounded)),
                  Tab(text: "Endgame", icon: Icon(Icons.elevator)),
                ],
              ),
            ),
            body: TabBarView(children: [
              widget.autonomous,
              widget.teleoperated,
              widget.endgame
            ])),
      ),
    );
  }
}
