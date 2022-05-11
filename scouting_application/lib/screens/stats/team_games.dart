import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/stats/game_data.dart';

class TeamGames extends StatefulWidget {
  TeamGames({Key? key, required this.teamID}) : super(key: key);
  final String teamID;

  @override
  State<TeamGames> createState() => _TeamGamesState();
}

class _TeamGamesState extends State<TeamGames> {
  late List<Map<String, dynamic>> games;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: Database.instance
                    .getTeamGamesStream(widget.teamID, Global.currentEventKey),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data == {}) {
                    return Center(child: Text("no games for this team"));
                  } else {
                    Map<String, dynamic> games =
                        snapshot.data as Map<String, dynamic>;
                    List<String> gameKeys = games.keys.toList();
                    gameKeys.sort((a, b) {
                      //yyyy[EVENT_CODE]_[COMP_LEVEL]m[MATCH_NUMBER]
                      int stageEqual = a // _[COMP_LEVEL]m
                          .substring(0, a.lastIndexOf("m"))
                          .compareTo(b.substring(0, b.lastIndexOf("m")));
                      if (stageEqual != 0) {
                        return stageEqual;
                      }

                      return int.parse(a.substring(a.lastIndexOf("m") + 1)) -
                          int.parse(b.substring(
                              b.lastIndexOf("m") + 1)); //[MATCH_NUMBER]
                    });
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: gameKeys.length,
                        itemBuilder: (context, index) {
                          final String gameKey = gameKeys[index];
                          return ListTile(
                            trailing: Global.isAdmin
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
                            title: Text(gameKey),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GameData(
                                          teamID: widget.teamID,
                                          data: Map<String, dynamic>.from(
                                              (games[gameKey]
                                                  as Map<dynamic, dynamic>)))));
                            },
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }

  void handleDeleteGame(String teamKey, String gameKey) {
    Database.instance.deleteGame(teamKey, gameKey, Global.currentEventKey);
  }
}
