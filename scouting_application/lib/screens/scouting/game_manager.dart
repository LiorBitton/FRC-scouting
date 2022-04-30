import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/menu.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/screens/scouting/tabs/autonomous.dart';
import 'package:scouting_application/screens/scouting/tabs/endgame.dart';
import 'package:scouting_application/screens/scouting/tabs/playstyle.dart';
import 'package:scouting_application/screens/scouting/tabs/teleoperated.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class GameManager extends StatefulWidget {
  //GameManager.matchNumber = matchNumber;
  // GameManager.teamID = teamID;
  // GameManager.isBlueAlliance = isSelected[0];
  GameManager(
      {Key? key,
      required this.isBlueAll,
      required this.matchKey,
      required this.teamNumber})
      : super(key: key);
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
  //initialized by ScoutPregame
  final String matchKey;
  final int teamNumber;
  final bool isBlueAll;
  static String matchID = '';
  static int teamID = 0;
  static bool isBlueAlliance = false;

  ///Upload the data from the game to the project's RealtimeDatabase
  ///
  ///
  static void submitGame(BuildContext context) {
    firebase_core.Firebase.initializeApp();
    final fb = FirebaseDatabase.instance;
    final ref = fb.ref();
    final dest = ref
        .child('teams')
        .child('$teamID')
        .child('games')
        .child(Global.current_event)
        .child('$matchID');
    Map<String, dynamic> data = {};
    List<EverCollector> dataCollectors = [];
    for (ScoutingTab tab in tabs) {
      dataCollectors.addAll(tab.getCollectors());
    }
    for (EverCollector collector in dataCollectors) {
      data.putIfAbsent(collector.getDataTag(), () => collector.getValue());
    }
    data.putIfAbsent('is_blue_alliance', () => isBlueAlliance);
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
    matchID = "";
    teamID = 0;
    isBlueAlliance = false;
    tabs = [autonomous, teleoperated, endgame, playstyle];
  }

  @override
  _GameManagerState createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  @override
  Widget build(BuildContext context) {
    GameManager.matchID = widget.matchKey;
    GameManager.isBlueAlliance = widget.isBlueAll;
    GameManager.teamID = widget.teamNumber;

    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                  'match: #${GameManager.matchID} | team: #${GameManager.teamID}'),
              automaticallyImplyLeading: false,
              bottom: TabBar(
                indicatorColor: Color.fromARGB(255, 50, 50, 35),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                      child:
                          Text("Auto", style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.do_not_touch, color: Colors.white)),
                  Tab(
                      child:
                          Text("Teleop", style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.drive_eta_rounded, color: Colors.white)),
                  Tab(
                      child: Text("Endgame",
                          style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.elevator, color: Colors.white)),
                  Tab(
                    child: Text("Playstyle",
                        style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.alt_route, color: Colors.white),
                  )
                ],
              ),
            ),
            body: TabBarView(children: GameManager.tabs)),
      ),
    );
  }
}
