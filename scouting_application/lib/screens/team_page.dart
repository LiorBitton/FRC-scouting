import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/TBA_team.dart';

class TeamPage extends StatelessWidget {
  TeamPage({Key? key, required this.teamNumber}) : super(key: key);
  final String teamNumber;
  late Future<TBATeam> futureTBATeam;
  late Future<List<Image>> futureImages;
  void initState() {
    futureImages = fetchTeamPhotos();
    futureTBATeam = fetchTBATeam();
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Scaffold(
        body: Center(
            child: Column(
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
        FutureBuilder<List<Image>>(
            future: futureImages,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!,
                );
              } else if (snapshot.hasError) {
                print('${snapshot.error}');
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            })
      ],
    )));
  }

  Future<TBATeam> fetchTBATeam() async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key':
          'jd8VzmoAQGS9Sax190JtjbJCgt9A3TgcaPyWbz1jYiIo3iIxLRsQFplJc0DMabrf',
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

  Future<List<Image>> fetchTeamPhotos() async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/media/$year');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key':
          'jd8VzmoAQGS9Sax190JtjbJCgt9A3TgcaPyWbz1jYiIo3iIxLRsQFplJc0DMabrf',
      'accept': 'application/json'
    });
    List<Image> out = [];
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      for (var mediaItem in res) {
        try {
          Image temp = Image.network(mediaItem['direct_url']);
          out.add(temp);
        } catch (Exception) {}
      }
      return out;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load TBATeam');
    }
    return out;
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }
}
