import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/screens/game_data.dart';

class TeamGames extends StatelessWidget {
  TeamGames({Key? key, required this.teamNumber}) : super(key: key);
  final String teamNumber;
  late List<Map<String, dynamic>> games;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref('teams/$teamNumber/games')
                    .onValue
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var data = (snapshot.data as DatabaseEvent).snapshot.value;
                    final info = Map<String, dynamic>.from(
                        (data as Map<dynamic, dynamic>));
                    List<String> gameIDs = info.keys.toList();
                    for (int i = 0; i < gameIDs.length; i++) {
                      gameIDs[i] = gameIDs[i].replaceAll(
                          'M', ''); //TODO change database way of saving events
                    }
                    gameIDs
                        .sort((a, b) => int.parse(a).compareTo(int.parse(b)));

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: gameIDs.length,
                        itemBuilder: (context, index) {
                          final String gameID = 'Q${gameIDs[index]}';
                          return ListTile(
                            title: Text(gameID),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GameData()));
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
}
