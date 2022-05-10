import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_application/classes/team_data.dart';
import 'package:scouting_application/classes/secret_constants.dart';
import 'package:scouting_application/classes/team_search_delegate.dart';
// import 'package:scouting_application/screens/analysis_gallery.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/screens/stats/team_homepage.dart';

class StatsLobby extends StatefulWidget {
  StatsLobby({Key? key}) : super(key: key);
  static Future<List<String>> fetchTeamsInCurrentEvent() async {
    final DataSnapshot snapshot =
        await FirebaseDatabase.instance.ref("settings/current_event").get();
    String eventKey = "none";
    if (snapshot.exists) {
      eventKey = snapshot.value.toString();
    }
    if (eventKey == "none") {
      return [];
    }
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$eventKey/teams/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> eventTeams = jsonDecode(response.body);
      List<String> teams = [];
      for (var team in eventTeams) {
        String teamKey = team["key"];
        teamKey = teamKey.replaceFirst("frc", "");
        teams.add(teamKey);
      }
      return teams;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load teams for event $eventKey');
    }
  }

  @override
  _StatsLobbyState createState() => _StatsLobbyState();
}

class _StatsLobbyState extends State<StatsLobby> {
  List<String> teams = [];
  List<List<String>> teamsData = [];
  Map<String, TeamData> teamData = {};
  bool nicknamesLoaded = false;
  bool allowSearch = false;
  @override
  void initState() {
    super.initState();
    loadCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stats'),
          actions: [
            allowSearch
                ? IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: TeamSearchDelegate(teams),
                          useRootNavigator: true);
                    },
                    icon: Icon(Icons.search))
                : Text("")
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
                        future: createCache(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: Image.asset(
                              "assets/loading.gif",
                              height: 125.0,
                              width: 125.0,
                            ));
                          } else {
                            allowSearch = true;
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
                                    subtitle:
                                        Text("${teamData[team]!.getName()}"),
                                    leading: imageFromBase64String(
                                            teamData[team]!.getAvatar()) ??
                                        Icon(Icons.people),
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
                        })
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<String> fetchTeamLogoAsString(String teamNumber) async {
    int year = new DateTime.now().year;
    if (teamData.containsKey(teamNumber)) {
      try {
        String b64logo = teamData[teamNumber]!.getAvatar();
        if (b64logo == "none") {
          //if team didnt upload an avatar
          // print("team #$teamNumber doesnt have an avatar");
          return "none";
        }
        if (b64logo != "") {
          //if avatar exists in cache
          // print("loaded $teamNumber photo from json");
          return b64logo;
        }
      } catch (e) {}
    }
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/media/$year');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      for (dynamic media in res) {
        //Fetching team's logo
        try {
          if (media["type"] == "avatar") {
            String b64logo = res[0]['details']['base64Image'].toString();
            teamData[teamNumber]!.setAvatar(b64logo);
            // print("saved $teamNumber photo to json");
            return b64logo;
          }
        } catch (exception) {
          print(exception);
          debugPrint('failed to download logo of $teamNumber');
          return "";
        }
      }
      teamData[teamNumber]!.setAvatar("none");
      return "none";
    } else {
      // If the server did not return a 200 OK response,
      throw Exception('Failed to load Team $teamNumber image');
    }
  }

  Image? imageFromBase64String(String base64String) {
    try {
      if (base64String == "none") return null;
      return Image.memory(base64Decode(base64String));
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String> fetchTeamNickname(String teamNumber) async {
    // if (!nicknamesLoaded) await loadCache();
    if (teamData.containsKey(teamNumber)) {
      // print("loaded $teamNumber from json");
      return teamData[teamNumber]!.getName();
    }

    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String nickname = jsonDecode(response.body)["nickname"];
      if (!teamData.containsKey(teamNumber)) {
        teamData.putIfAbsent(
            teamNumber, () => TeamData(name: nickname, avatar: ""));
        // print("saved $teamNumber to json");
      }
      return nickname;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Team $teamNumber nickname');
    }
  }

  ///loads data from cache into teamData{}. creates a new file if cache file doesnt exist
  Future<void> loadCache() async {
    if (nicknamesLoaded) return;
    nicknamesLoaded = true;
    String fileName = 'teamData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + '/' + fileName);
    if (!file.existsSync()) {
      // print("creating file");
      file = await file.create();
      await saveCache();
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
    String fileName = 'teamData.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    file.writeAsStringSync(json.encode(teamData));
  }

  Future<String> createCache() async {
    await loadCache();
    final List<String> teamsTemp = await StatsLobby.fetchTeamsInCurrentEvent();
    if (teamsTemp == []) {
      var ref = FirebaseDatabase.instance.ref('teams');
      DataSnapshot snapshot = await ref.get();
      var data = snapshot.value;
      final info = Map<String, dynamic>.from((data as Map<dynamic, dynamic>));
      teams = info.keys.toList();
      teams.remove("9999");
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

  //

}
