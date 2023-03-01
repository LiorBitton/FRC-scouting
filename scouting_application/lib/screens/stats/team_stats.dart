import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/stats/game_data.dart';

class TeamStats extends StatelessWidget {
  const TeamStats({Key? key, required this.teamID}) : super(key: key);
  final String teamID;
  Future<List<Map<String, String>>> getStats() async {
    try {
      final FirebaseDatabase db = FirebaseDatabase.instance;
      DataSnapshot snapshot = await db
          .ref(
              "teams/${int.parse(teamID)}/events/${Global.instance.currentEventKey}/custom")
          .get()
          .timeout(Duration(seconds: 5));
      if (!snapshot.exists || snapshot.value == null) {
        return [
          {"": ""}
        ];
      }
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      List<Map<String, String>> keys = [];
      for (MapEntry<String, dynamic> entry in data.entries) {
        keys.add({entry.key: entry.value.toString()});
      }
      return keys;
    } catch (exception, stack) {
      print("error");
      Database.instance.log('error getting custom information');
      Database.instance.recordError(exception, stack);
      return [
        {"": ""}
      ];
    }
  }

  void requestTeamStats() {
    final FirebaseDatabase db = FirebaseDatabase.instance;
    db
        .ref("listeners/update_team_stats/$teamID")
        .set(Global.instance.currentEventKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Team $teamID - Stats"), actions: [
        IconButton(
          icon: Icon(Icons.request_page_outlined),
          onPressed: () {
            requestTeamStats();
          },
        )
      ]),
      body: ListView(
        children: [
          FutureBuilder(
              future: getStats(),
              builder: (context, snapshot) {
                List<Map<String, String>> keys = [
                  {"": ""}
                ];
                if (snapshot.hasData) {
                  keys =
                      List<Map<String, String>>.from(snapshot.data as dynamic);
                  if (keys.length == 1) {
                    if (keys[0].containsKey("")) {
                      return Text(
                          "No data found, click the button in the top right to request data from Peleg");
                    }
                  }
                  return CategoryList(data: keys, title: "stats");
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}
