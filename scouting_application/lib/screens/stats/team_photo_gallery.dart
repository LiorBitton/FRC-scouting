import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/tba_client.dart';
import 'package:scouting_application/screens/scouting/add_team_photo.dart';

class TeamPhotoGallery extends StatelessWidget {
  TeamPhotoGallery({Key? key, required this.teamNumber}) : super(key: key);
  final String teamNumber;
  late Future<List<Image>> futureImages;
  @override
  Widget build(BuildContext context) {
    futureImages = fetchTeamPhotos();
    return Scaffold(
      appBar: AppBar(
        title: Text("Team $teamNumber Photos"),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTeamPhoto(teamID: teamNumber)));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Image>>(
              future: futureImages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data as List<Image>).isEmpty) {
                    return Text("There are no photos of this team");
                  }
                  return Column(
                    children: snapshot.data!,
                  );
                } else if (snapshot.hasError) {
                  print('${snapshot.error}');
                }
                return LinearProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Image>> fetchTeamPhotos() async {
    Map<String, List<String>> images =
        await TBAClient.instance.fetchTeamPhotos(teamNumber);
    List<String> urlImages = images["url"]!;
    List<String> b64images = images["b64"]!;
    List<String> databaseImages =
        await Database.instance.getTeamImages(teamNumber);
    urlImages.addAll(databaseImages);
    List<Image> out = [];
    for (String url in urlImages) {
      out.add(Image.network(url));
    }
    for (String b64 in b64images) {
      out.add(imageFromBase64String(b64));
    }
    return out;
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }
}
