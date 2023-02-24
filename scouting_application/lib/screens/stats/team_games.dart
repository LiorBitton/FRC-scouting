import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/scouting/game_manager.dart';
import 'package:scouting_application/screens/stats/game_data.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class TeamGames extends StatefulWidget {
  TeamGames({Key? key, required this.teamID, required this.eventKey})
      : super(key: key);
  final String teamID;
  final String eventKey;
  @override
  State<TeamGames> createState() => _TeamGamesState();
}

class _TeamGamesState extends State<TeamGames> {
  late List<Map<String, dynamic>> games;
  Map<String, String> consistency = {};
  Map<String, String> avgs = {};
  @override
  void initState() {
    asyncInit();
    super.initState();
  }

  void asyncInit() async {
    consistency = await Database.instance
        .getEventConsistency(widget.teamID, widget.eventKey)
        .then((value) => Map<String, String>.from(value));
    avgs = await Database.instance
        .getEventAvgs(widget.teamID, widget.eventKey)
        .then((value) => Map<String, String>.from(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Team ${widget.teamID} - ${widget.eventKey.substring(4)} Games")),
      body: FutureBuilder(
        future: Database.instance.teamHasGames(widget.teamID, widget.eventKey),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }
          return !(snapshot.data as bool)
              ? Center(
                  child: Text(
                      "No games for team ${widget.teamID} in event ${widget.eventKey}"))
              : Column(
                  children: [
                    StreamBuilder(
                        stream: Database.instance
                            .getTeamGamesStream(widget.teamID, widget.eventKey),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.data == {}) {
                            return Center(
                                child: Text("no games for this team"));
                          } else {
                            Map<String, dynamic> games =
                                snapshot.data as Map<String, dynamic>;
                            List<String> gameKeys = games.keys.toList();
                            gameKeys.sort(compareGameKeys);
                            //   bool rfa = a.startsWith("rf");
                            //   bool rfb = b.startsWith("rf");
                            //   if (rfa && rfb) {
                            //     int matcha = int.parse(a.substring(2));
                            //     int matchb = int.parse(b.substring(2));
                            //     return matcha.compareTo(matchb);
                            //   } else if (rfa) {
                            //     return -1;
                            //   } else if (rfb) {
                            //     return 1;
                            //   }

                            //   //yyyy[EVENT_CODE]_[COMP_LEVEL]m[MATCH_NUMBER]
                            //   int stageEqual = a // _[COMP_LEVEL]m
                            //       .substring(0, a.lastIndexOf("m"))
                            //       .compareTo(
                            //           b.substring(0, b.lastIndexOf("m")));
                            //   if (stageEqual != 0) {
                            //     return stageEqual;
                            //   }
                            //   //if match stage is not different, compare by match number
                            //   return int.parse(
                            //           a.substring(a.lastIndexOf("m") + 1)) -
                            //       int.parse(b.substring(
                            //           b.lastIndexOf("m") + 1)); //[MATCH_NUMBER]

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: gameKeys.length,
                              itemBuilder: (context, index) {
                                final String gameKey = gameKeys[index];
                                return ListTile(
                                  trailing: Global.instance.isAdmin
                                      ? IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              handleDeleteGame(
                                                  widget.teamID, gameKey);
                                            });
                                          },
                                        )
                                      : Text(""),
                                  title: Text(gameKeyToTitle(gameKey)),
                                  subtitle: Text(gameKey),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GameData(
                                                  consistency: consistency,
                                                  teamID: widget.teamID,
                                                  data:
                                                      Map<String, dynamic>.from(
                                                          (games[gameKey]
                                                              as Map<dynamic,
                                                                  dynamic>)),
                                                  avgs: avgs,
                                                )));
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  color: CustomTheme.teamColor, // Colors.black,
                                  thickness: 3,
                                );
                              },
                            );
                          }
                        }),
                  ],
                );
        },
      ),
    );
  }

  int compareGameKeys(String gameKeyA, gameKeyB) {
    bool rfa = gameKeyA.startsWith("rf");
    bool rfb = gameKeyB.startsWith("rf");
    if (rfa && rfb) {
      int matcha = int.parse(gameKeyA.substring(2));
      int matchb = int.parse(gameKeyB.substring(2));
      return matcha.compareTo(matchb);
    } else if (rfa) {
      return -1;
    } else if (rfb) {
      return 1;
    }

    //yyyy[EVENT_CODE]_[COMP_LEVEL]m[MATCH_NUMBER]
    int stageEqual = gameKeyA // _[COMP_LEVEL]m
        .substring(0, gameKeyA.lastIndexOf("m"))
        .compareTo(gameKeyB.substring(0, gameKeyB.lastIndexOf("m")));
    if (stageEqual != 0) {
      return stageEqual;
    }
    //if match stage is not different, compare by match number
    return int.parse(gameKeyA.substring(gameKeyA.lastIndexOf("m") + 1)) -
        int.parse(
            gameKeyB.substring(gameKeyB.lastIndexOf("m") + 1)); //[MATCH_NUMBER]
  }

  String gameKeyToTitle(String gameKey) {
    if (gameKey.startsWith("rf")) {
      int matchNum = int.parse(gameKey.substring(2));
      return "Match $matchNum";
    }
    String matchNumber = gameKey.substring(gameKey.lastIndexOf("m") + 1);
    if (gameKey.startsWith("qm")) {
      return "Qualification $matchNumber";
    }
    if (gameKey.startsWith("f")) {
      return "Final $matchNumber";
    }

    String setNumber = gameKey.characters.elementAt(2);
    if (gameKey.startsWith("qf")) {
      return "Quarterfinal $setNumber-$matchNumber";
    }
    if (gameKey.startsWith("sf")) {
      return "Semifinal $setNumber-$matchNumber";
    }
    return " ";
  }

  void handleDeleteGame(String teamKey, String gameKey) {
    Database.instance
        .deleteGame(teamKey, gameKey, Global.instance.currentEventKey);
  }
}
