import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_application/classes/secret_constants.dart';
import 'package:scouting_application/classes/team_search_delegate.dart';
// import 'package:scouting_application/screens/analysis_gallery.dart';
import 'package:scouting_application/screens/stats/team_homepage.dart';
import 'package:http/http.dart' as http;

class StatsLobby extends StatefulWidget {
  StatsLobby({Key? key}) : super(key: key);

  @override
  _StatsLobbyState createState() => _StatsLobbyState();
}

class _StatsLobbyState extends State<StatsLobby> {
  List<String> teams = [];
  List<List<String>> teamsData = [];
  Map<String, dynamic> teamNicknames = {"": ""};
  bool nicknamesLoaded = false;
  @override
  void initState() {
    super.initState();
    loadNicknames();
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
                                    subtitle: FutureBuilder<String>(
                                      future: fetchTeamNickname(team),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data != null) {
                                            return Text("${snapshot.data}");
                                          }
                                          return Text("");
                                        }
                                        return Text("");
                                      },
                                    ),
                                    leading: FutureBuilder<Widget?>(
                                      future: fetchTeamLogo(team),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data != null) {
                                            try {
                                              return snapshot.data! as Image;
                                            } catch (e) {
                                              return Icon(Icons.people);
                                            }
                                          }
                                          return Icon(Icons.people);
                                        }
                                        return CircularProgressIndicator(
                                          color: Colors.green,
                                        );
                                      },
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

  Future<Widget?> fetchTeamLogo(String teamNumber) async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/media/$year');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
    Widget? out = Text("ok");
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      if (res == null) {
        return out;
      }
      for (dynamic media in res) {
        //Fetching team's logo
        try {
          if (media["type"] == "avatar")
            out = imageFromBase64String(
                res[0]['details']['base64Image'].toString());
        } catch (exception) {
          debugPrint('failed to download logo of $teamNumber');
          return Text("ok");
        }
      }
      return out;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load TBATeam');
    }
  }

  Image? imageFromBase64String(String base64String) {
    try {
      return Image.memory(base64Decode(base64String));
    } catch (e) {
      return null;
    }
  }

  Future<String> fetchTeamNickname(String teamNumber) async {
    if (!nicknamesLoaded) await loadNicknames();
    if (teamNicknames.containsKey(teamNumber)) {
      print("loaded $teamNumber from json");
      return teamNicknames[teamNumber]!;
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
      if (!teamNicknames.containsKey(teamNumber)) {
        teamNicknames.putIfAbsent(teamNumber, () => nickname);
        saveNicknamesToFile();
        print("saved $teamNumber to json");
      }
      return nickname;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load TBATeam');
    }
  }

  Future<void> loadNicknames() async {
    if (nicknamesLoaded) return;
    nicknamesLoaded = true;
    String fileName = 'teamData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + '/' + fileName);
    if (!file.existsSync()) {
      print("creating file");
      file = await file.create();
      await saveNicknamesToFile();
    }
    var jsonData = file.readAsStringSync();
    var jsonResponse = jsonDecode(jsonData);
    teamNicknames =
        Map<String, dynamic>.from(jsonResponse as Map<String, dynamic>);
  }

  Future<void> saveNicknamesToFile() async {
    String fileName = 'teamData.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + '/' + fileName);
    file.writeAsStringSync(json.encode(teamNicknames));
  }
}
