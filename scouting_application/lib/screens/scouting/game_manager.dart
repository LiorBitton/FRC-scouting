import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/homepage.dart';
import 'package:scouting_application/screens/scouting/display_qr.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/screens/scouting/tabs/general.dart';
import 'package:scouting_application/widgets/collectors/count_collector.dart';
import 'package:scouting_application/widgets/collectors/dropdown_collector.dart';
import 'package:scouting_application/widgets/collectors/duration_collector.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/collectors/plus_minus_collector.dart';
import 'package:scouting_application/widgets/collectors/switch_collector.dart';
import 'package:scouting_application/widgets/collectors/text_collector.dart';

class GameManager extends StatefulWidget {
  GameManager(
      {Key? key,
      required this.isBlueAll,
      required this.matchKey,
      required this.teamNumber})
      : super(key: key);
  static ScoutingTab autonomous = new ScoutingTab(
    collectors: toEverCollectorList(Global.instance.autoCollectors),
  );
  static ScoutingTab teleoperated = new ScoutingTab(
      collectors: toEverCollectorList(Global.instance.teleCollectors));
  static ScoutingTab endgame = new ScoutingTab(
      collectors: toEverCollectorList(Global.instance.endCollectors));
  static GeneralTab playstyle = new GeneralTab(
    collectors: toEverCollectorList(Global.instance.generalCollectors),
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
  static void submitGame(BuildContext context) async {
    notifyScoutingFinished();
    Map<String, dynamic> data = {};
    List<EverCollector> dataCollectors = [];
    for (ScoutingTab tab in tabs) {
      dataCollectors.addAll(tab.getCollectors());
    }
    for (EverCollector collector in dataCollectors) {
      data.putIfAbsent(collector.getDataTag(), () => collector.getValue());
    }
    data.putIfAbsent('is_blue_alliance', () => isBlueAlliance);
    if (Global.instance.offlineEvent) {
      displayDataAsQR(context, data, matchID, teamID.toString());
    } else {
      try {
        final fb = FirebaseDatabase.instance;
        final ref = fb.ref();
        final dest = ref
            .child('teams')
            .child('$teamID')
            .child(Global.instance.currentEventKey)
            .child('$matchID');
        //limit connection to  an 8 seconds trial, else show QR
        await dest.set(data).then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()));
        }).timeout(Duration(seconds: 8), onTimeout: () {
          displayDataAsQR(context, data, matchID, teamID.toString());
        });
      } catch (e) {
        print(e);
        displayDataAsQR(context, data, matchID, teamID.toString());
      }
    }

    reset();
  }

  ///Takes match data as a Map and displays it as a QR
  static void displayDataAsQR(BuildContext context, Map<String, dynamic> data,
      String matchKey, String teamID) {
    Map<String, dynamic> out = {
      "matchKey": matchKey,
      "teamID": teamID,
      "data": data
    };
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayQr(data: out.toString())));
  }

  static void notifyScoutingFinished() {
    Database.instance.notifyScoutingFinished(GameManager.teamID.toString());
  }

  static void reset() {
    autonomous = new ScoutingTab(
        collectors: toEverCollectorList(Global.instance.autoCollectors));
    teleoperated = new ScoutingTab(
        collectors: toEverCollectorList(Global.instance.teleCollectors));
    endgame = new ScoutingTab(
        collectors: toEverCollectorList(Global.instance.endCollectors));
    playstyle = new GeneralTab(
      collectors: toEverCollectorList(Global.instance.generalCollectors),
      onSubmit: (BuildContext context) {
        submitGame(context);
      },
    );
    matchID = "";
    teamID = 0;
    isBlueAlliance = false;
    tabs = [autonomous, teleoperated, endgame, playstyle];
  }

  static List<EverCollector> toEverCollectorList(List<String> collectors) {
    List<EverCollector> out = [];
    for (int i = 0; i < collectors.length; ++i) {
      EverCollector? collector = toEverCollector(collectors[i]);
      if (collector != null) out.add(collector);
    }
    return out;
  }

  static EverCollector? toEverCollector(String collector) {
    //title;dataTag;type;option1,option2,option3(only for dropdown)
    final List<String> split = collector.split(";");
    if (split.length != 4 && split.length != 3) {
      print("error occured with $collector translation");
      return null;
    }
    final String title = split[0];
    final String dataTag = split[1];
    final String type = split[2];
    switch (type) {
      case "plu":
        return PlusMinusCollector(dataTag: dataTag, title: title);
      case "dur":
        return DurationCollector(dataTag: dataTag, title: title);
      case "swi":
        return SwitchCollector(title: title, dataTag: dataTag);
      case "dro":
        final List<String> options = split[3].split(",");
        return DropDownCollector(
            dataTag: dataTag, options: options, title: title);
      case "tex":
        return TextCollector(dataTag: dataTag, title: title, hintText: title);
      case "cou":
        return CountCollector(title: title, dataTag: dataTag);
    }
    return null;
  }

  @override
  _GameManagerState createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  late Future<bool> futureScoutingOccupied;

  @override
  void initState() {
    super.initState();
    futureScoutingOccupied = _notifyScoutingTeam();
  }

  @override
  Widget build(BuildContext context) {
    GameManager.matchID = widget.matchKey;
    GameManager.isBlueAlliance = widget.isBlueAll;
    GameManager.teamID = widget.teamNumber;

    return FutureBuilder<bool>(
        future: futureScoutingOccupied,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (!(snapshot.data!)) {
              Navigator.pop(context);
            } else {
              return WillPopScope(
                onWillPop: () async => false,
                child: DefaultTabController(
                  length: 4,
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text('Scouting Team ${GameManager.teamID}'),
                        actions: [
                          IconButton(
                              onPressed: () {
                                GameManager.reset();
                                _notifyScoutingFinished();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()));
                              },
                              icon: Icon(Icons.exit_to_app))
                        ],
                        automaticallyImplyLeading: false,
                        bottom: TabBar(
                          indicatorColor: Color.fromARGB(255, 50, 50, 35),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 5,
                          tabs: [
                            Tab(
                                child: Text("Auto",
                                    style: TextStyle(color: Colors.white)),
                                icon: Icon(Icons.do_not_touch,
                                    color: Colors.white)),
                            Tab(
                                child: Text("Teleop",
                                    style: TextStyle(color: Colors.white)),
                                icon: Icon(Icons.drive_eta_rounded,
                                    color: Colors.white)),
                            Tab(
                                child: Text("Endgame",
                                    style: TextStyle(color: Colors.white)),
                                icon:
                                    Icon(Icons.elevator, color: Colors.white)),
                            Tab(
                              child: Text("General",
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
          return Scaffold(
              body: Center(
            child: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                children: [CircularProgressIndicator(), Text("Loading...")]),
          ));
        }));
  }

  Future<bool> _notifyScoutingTeam() async {
    if (Global.instance.offlineEvent) return true;
    return await Database.instance
        .notifyStartScouting(widget.teamNumber.toString())
        .onError((error, stackTrace) => true);
  }

  void _notifyScoutingFinished() {
    final fb = FirebaseDatabase.instance;
    final ref = fb.ref();
    ref
        .child('sync')
        .child('currently_scouted')
        .child(GameManager.teamID.toString())
        .remove();
  }
}
