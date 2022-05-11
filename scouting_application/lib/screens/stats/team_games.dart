import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
                stream: FirebaseDatabase.instance
                    .ref(
                        'teams/${widget.teamID}/games/${Global.currentEventKey}')
                    .onValue
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var data = (snapshot.data as DatabaseEvent).snapshot.value;
                    if (data == null) {
                      return Center(child: Text("no games for this team"));
                    }
                    final info = Map<String, dynamic>.from(
                        (data as Map<dynamic, dynamic>));
                    List<String> gameIDs = info.keys.toList();
                    gameIDs.sort((a, b) {
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
                        itemCount: gameIDs.length,
                        itemBuilder: (context, index) {
                          final String gameKey = gameIDs[index];
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
                                              (info[gameKey]
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
    FirebaseDatabase.instance
        .ref("teams/$teamKey/games/${Global.currentEventKey}/$gameKey")
        .remove();
  }
}
