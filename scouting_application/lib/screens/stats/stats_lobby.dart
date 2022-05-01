import 'dart:core';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:scouting_application/classes/team_search_delegate.dart';
// import 'package:scouting_application/screens/analysis_gallery.dart';
import 'package:scouting_application/screens/stats/team_homepage.dart';

class StatsLobby extends StatefulWidget {
  StatsLobby({Key? key}) : super(key: key);

  @override
  _StatsLobbyState createState() => _StatsLobbyState();
}

class _StatsLobbyState extends State<StatsLobby> {
  List<String> teams = [];
  List<List<String>> teamsData = [];
  @override
  void initState() {
    updateItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stats'),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: TeamSearchDelegate(teams),
                      useRootNavigator: true);
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .ref('teams')
                            .onValue
                            .asBroadcastStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            var data =
                                (snapshot.data as DatabaseEvent).snapshot.value;
                            final info = Map<String, dynamic>.from(
                                (data as Map<dynamic, dynamic>));
                            teams = info.keys.toList();
                            teams.remove("9999");
                            teams.sort(
                                (a, b) => int.parse(a).compareTo(int.parse(b)));

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: teams.length,
                                itemBuilder: (context, index) {
                                  String team = teams[index];
                                  return ListTile(
                                    title: Text(
                                      team,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TeamHomepage(
                                                      teamNumber: team)));
                                    },
                                  );
                                });
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void updateItems() async {
    // teams = getTeams();
    // items = createExpansionPanelList();
  }

  Future<List<String>> getTeams() async {
    firebase_core.Firebase.initializeApp();
    final fb = FirebaseDatabase.instance;
    final ref = fb.ref();
    List<String> teams = [];
    DataSnapshot data = await ref.child("teams").get();
    final info =
        Map<String, dynamic>.from((data.value as Map<dynamic, dynamic>));
    List<String> teamNumbers = [];
    for (var teamID in info.keys) {
      teamNumbers.add(teamID);
      List<String> teamData = [];
      try {
        teamData.add('===DATA FROM LAST GAME===');
        //add the data from teams/teamID/last_game
        final games = Map<String, dynamic>.from(info[teamID]);
        //find last game
        String lastGameKey = "No Games Yet";
        for (var key in games.keys) {
          if (key.startsWith("G")) {
            if (key.compareTo(lastGameKey) > 0) {
              lastGameKey = key;
            }
          }
        }
        final lastGame = Map<String, dynamic>.from(info[teamID][lastGameKey]);

        teamData.add(lastGame.values.toString());
        stderr.writeln(lastGame.values.toString());
      } catch (Exception) {
        teamData.add('no statistics for this team yet');
      }
      teamsData.add(teamData);
    }

    return teams;
  }
}
