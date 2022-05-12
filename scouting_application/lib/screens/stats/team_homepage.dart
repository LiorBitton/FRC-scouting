import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/stats/team_photo_gallery.dart';
import 'package:scouting_application/screens/stats/team_games.dart';

class TeamHomepage extends StatelessWidget {
  TeamHomepage({Key? key, required this.teamNumber}) : super(key: key);
  final String teamNumber;

  void initState() {}

  @override
  Widget build(BuildContext context) {
    initState();
    return Scaffold(
        appBar: AppBar(title: Text("Team $teamNumber")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(Icons.image_search),
                iconSize: 50,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeamPhotoGallery(
                                teamNumber: teamNumber,
                              )));
                }),
            IconButton(
                icon: Icon(Icons.checklist),
                iconSize: 50,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeamGames(
                                teamID: teamNumber,
                                eventKey: Global.currentEventKey,
                              )));
                }),
          ],
        )));
  }
}
