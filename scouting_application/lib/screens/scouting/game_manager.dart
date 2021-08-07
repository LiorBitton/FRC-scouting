import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/screens/menu.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/screens/scouting/tabs/autonomous.dart';
import 'package:scouting_application/screens/scouting/tabs/endgame.dart';
import 'package:scouting_application/screens/scouting/tabs/playstyle.dart';
import 'package:scouting_application/screens/scouting/tabs/teleoperated.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class GameManager extends StatefulWidget {
  GameManager({Key? key}) : super(key: key);
  static ScoutAutonomous autonomous = new ScoutAutonomous();
  static TeleoperatedTab teleoperated = new TeleoperatedTab();
  static EndgameTab endgame = new EndgameTab();
  static PlaystyleTab playstyle = new PlaystyleTab(
    onSubmit: (BuildContext context) {
      submitGame(context);
    },
  );
  static List<ScoutingTab> tabs = [
    autonomous,
    teleoperated,
    endgame,
    playstyle
  ];
  static int matchNumber = 0;
  static int teamID = 0;

  ///Upload the data from the game to the project's RealtimeDatabase
  ///
  ///
  static void submitGame(BuildContext context) {
    firebase_core.Firebase.initializeApp();
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    final dest = ref
        .child('teams')
        .child('$teamID')
        .child('games')
        .child('G$matchNumber');
    Map<String, dynamic> data = {};
    List<EverCollector> dataCollectors = [];
    for (ScoutingTab tab in tabs) {
      dataCollectors.addAll(tab.getCollectors());
    }
    for (EverCollector collector in dataCollectors) {
      data.putIfAbsent(collector.getDataTag(), () => collector.getValue());
    }
    print(data);
    dest.set(data);
    reset();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
  }

  static void reset() {
    autonomous = new ScoutAutonomous();
    teleoperated = new TeleoperatedTab();
    endgame = new EndgameTab();
    playstyle = new PlaystyleTab(
      onSubmit: (BuildContext context) {
        submitGame(context);
      },
    );
    matchNumber = 0;
    teamID = 0;
    tabs = [autonomous, teleoperated, endgame, playstyle];
  }

  @override
  _GameManagerState createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                  'match: #${GameManager.matchNumber} | team: #${GameManager.teamID}'),
              automaticallyImplyLeading: false,
              bottom: TabBar(
                indicatorColor: Color.fromARGB(255, 50, 50, 35),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                tabs: [
                  Tab(text: "Auto", icon: Icon(Icons.do_not_touch)),
                  Tab(text: "Teleop", icon: Icon(Icons.drive_eta_rounded)),
                  Tab(text: "Endgame", icon: Icon(Icons.elevator)),
                  Tab(
                    text: 'Playstyle',
                    icon: Icon(Icons.alt_route),
                  )
                ],
              ),
            ),
            body: TabBarView(children: GameManager.tabs)),
      ),
    );
  }
}
