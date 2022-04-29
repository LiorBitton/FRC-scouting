import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/TBA_team.dart';
import 'package:scouting_application/classes/secret_constants.dart';
import 'package:scouting_application/screens/team_gallery.dart';
import 'package:scouting_application/screens/team_games.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class TeamPage extends StatelessWidget {
  TeamPage({Key? key, required this.teamNumber}) : super(key: key);
  final String teamNumber;
  late Future<TBATeam> futureTBATeam;

  void initState() {
    futureTBATeam = fetchTBATeam();
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FutureBuilder<TBATeam>(
          future: futureTBATeam,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
        MenuButton(
            title: "Photos",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamGallery(
                            teamNumber: teamNumber,
                          )));
            }),
        MenuButton(
            title: "Games",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamGames(
                            teamNumber: teamNumber,
                          )));
            }),
      ],
    )));
  }

  Future<TBATeam> fetchTBATeam() async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TBATeam.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load TBATeam');
    }
  }
}
