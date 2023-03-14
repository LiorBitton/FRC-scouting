import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart'; //TODO related to next todo
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/tba_client.dart';
import 'package:scouting_application/classes/team_data.dart';
import 'package:scouting_application/classes/team_search_delegate.dart';
import 'package:scouting_application/screens/stats/team_homepage.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class StatsLobby extends StatefulWidget {
  StatsLobby({Key? key}) : super(key: key);
  @override
  _StatsLobbyState createState() => _StatsLobbyState();
}

class _StatsLobbyState extends State<StatsLobby> {
  List<String> teams = [];
  Map<String, TeamData> teamData = {};
  bool nicknamesLoaded = false;

  late Future<String> readyForStart;
  @override
  void initState() {
    super.initState();
    try {
      readyForStart = createCache();
    } catch (e) {}
    //TODO use isolate.spawn() with a function to download all of the images on the first run
    // even better, display the page while images are being downloaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stats'),
          actions: [
            FutureBuilder<String>(
                future: readyForStart,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return IconButton(
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: TeamSearchDelegate(teamData),
                              useRootNavigator: true);
                        },
                        icon: Icon(Icons.search));
                  }
                })
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    FutureBuilder<String>(
                        future: readyForStart,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: teamData.length,
                              itemBuilder: (context, index) {
                                String team = teamData.keys.elementAt(index);
                                String teamName = teamData[team]!.getName();
                                Widget? teamAvatar = imageFromBase64String(
                                    teamData[team]!.getAvatar());
                                return ListTile(
                                  title: Text(team),
                                  subtitle: Text(teamName),
                                  leading: teamAvatar ?? Icon(Icons.people),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TeamHomepage(
                                                teamNumber: team,
                                                teamName: teamName,
                                                teamAvatar: teamAvatar)));
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
                        })
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<String> fetchTeamLogoAsString(String teamNumber) async {
    if (teamData.containsKey(teamNumber)) {
      try {
        String b64logo = teamData[teamNumber]!.getAvatar();
        if (b64logo == "none") {
          //if team didnt upload an avatar
          return "none";
        }
        if (b64logo != "") {
          //if avatar exists in cache
          // print("loaded $teamNumber photo from json");
          return b64logo;
        }
      } catch (e) {}
    }
    String b64avatar =
        await TBAClient.instance.fetchTeamLogoAsString(teamNumber);
    teamData[teamNumber]!.setAvatar(b64avatar);
    return b64avatar;
  }

  Image? imageFromBase64String(String base64String) {
    try {
      if (base64String == "none") return null;
      return Image.memory(base64Decode(base64String));
    } catch (e) {
      return null;
    }
  }

  Future<String> fetchTeamNickname(String teamNumber) async {
    if (teamData.containsKey(teamNumber)) {
      return teamData[teamNumber]!.getName();
    }

    String nickname = await TBAClient.instance.fetchTeamNickname(teamNumber);
    if (!teamData.containsKey(teamNumber)) {
      teamData.putIfAbsent(
          teamNumber, () => TeamData(name: nickname, avatar: ""));
      return nickname;
    } else {
      throw Exception('Failed to load Team $teamNumber nickname');
    }
  }

  final String fileName = 'teamData.json';

  ///loads data from cache into teamData{}. creates a new file if cache file doesnt exist
  Future<void> loadCache() async {
    if (nicknamesLoaded) return;
    nicknamesLoaded = true;
    String fileName = 'teamData.json';
    final Directory dir = await getApplicationDocumentsDirectory();
    File file = File(dir.path + '/' + fileName);

    if (!file.existsSync()) {
      file = await file.create();
      await saveCache();
    }
    File timestampFile = File(dir.path + '/' + ts_file);
    if (timestampFile.existsSync()) {
      String cache_time_str = timestampFile.readAsStringSync().split("\n")[0];
      String cached_event = timestampFile.readAsStringSync().split("\n")[1];
      if (cached_event != Global.instance.currentEventKey) {
        return;
      }
      int cacheTime = int.parse(cache_time_str);
      int currTime = DateTime.now().millisecondsSinceEpoch;
    }

    var jsonData = file.readAsStringSync();
    var jsonResponse = jsonDecode(jsonData);
    Map<String, dynamic> out =
        Map<String, dynamic>.from(jsonResponse as Map<String, dynamic>);
    for (String s in out.keys) {
      teamData[s] = TeamData.fromJson(out[s]);
    }
  }

  Future<void> saveCache() async {
    var dir = await getApplicationDocumentsDirectory();
    File file = File(dir.path + '/' + fileName);
    file.writeAsStringSync(json.encode(teamData));
  }

  Future<List<String>> fetchTeamsFromTBA(String eventKey) {
    return TBAClient.instance.fetchTeamsInEvent(eventKey);
  }

  final String teamsFile = "teams.json";
  final String ts_file = "teams_ts.txt";
  final int MAX_TIME = 3600000; //refresh cache every 1 hour
  Future<List<String>> getTeamsInEvent(String eventKey) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    List<String> teams = [];
    //Get Teams from memory
    File tsfile = File(dir.path + '/' + ts_file);
    if (tsfile.existsSync()) {
      String cache_time_str = tsfile.readAsStringSync().split("\n")[0];
      String cached_event = tsfile.readAsStringSync().split("\n")[1];
      log(eventKey + ":" + cached_event);

      int cacheTime = int.parse(cache_time_str);
      int currTime = DateTime.now().millisecondsSinceEpoch;
      File file = File(dir.path + '/' + teamsFile);
      //if cache is fresh and the cache is for the required event and the cache data file exists
      if (cacheTime + MAX_TIME >= currTime &&
          eventKey == cached_event &&
          file.existsSync()) {
        //read the cache data file and return its contents
        var jsonData = file.readAsStringSync();
        var jsonResponse = jsonDecode(jsonData);
        List<String> out = List<String>.from(jsonResponse as List<dynamic>);
        if (out.isNotEmpty) {
          log("from cache");
          return out;
        }
      }
    }
    //else(if there is no valid cache)
    teams = await fetchTeamsFromTBA(eventKey);
    if (teams.isNotEmpty) {
      File tsfile = File(dir.path + '/' + ts_file);
      int time = DateTime.now().millisecondsSinceEpoch;
      tsfile.writeAsStringSync(time.toString() + "\n" + eventKey);
      File file = File(dir.path + '/' + teamsFile);
      file.writeAsStringSync(json.encode(teams));
      log("from TBA");
      return teams;
    }
    return [];
  }

  Future<String> createCache() async {
    await loadCache();

    List<String> teamsTemp =
        await getTeamsInEvent(Global.instance.currentEventKey);
    // try {
    //   teamsTemp = await TBAClient.instance
    //       .fetchTeamsInEvent(Global.instance.currentEventKey)
    //       .timeout(const Duration(seconds: 5), onTimeout: () {
    //     return [];
    //   });
    // } catch (e) {
    //   print("I caught an error look: \n $e");
    // }
    if (teamsTemp.isEmpty) {
      //If no connection to TBA
      //Show all teams info in Database
      //TODO replace with Database class function that returns all of the teams
      var ref = FirebaseDatabase.instance.ref('teams');
      try {
        ref.once().then((dbEvent) {
          if (dbEvent.snapshot.exists) {
            var data = dbEvent.snapshot.value;
            final info =
                Map<String, dynamic>.from((data as Map<dynamic, dynamic>));
            teams = info.keys.toList();
            teams.remove("9999");
          }
        }).timeout(Duration(seconds: 5), onTimeout: () {
          throw Exception("no connection to firebase too");
        });
      } catch (e) {
        //If no connection from Database and TBA
        // for(String team in teamData.keys)
        print("no connection at all");
      }
    } else {
      teams = teamsTemp;
    }
    teams.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    for (String team in teams) {
      String name = await fetchTeamNickname(team);
      String avatar = await fetchTeamLogoAsString(team);
      teamData.putIfAbsent(team, () => TeamData(name: name, avatar: avatar));
    }
    saveCache();
    return "okay";
  }
}
