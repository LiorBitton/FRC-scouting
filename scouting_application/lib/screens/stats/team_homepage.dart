import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/screens/stats/team_events.dart';
import 'package:scouting_application/screens/stats/team_games.dart';
import 'package:scouting_application/screens/stats/team_photo_gallery.dart';

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
            FutureBuilder(
                future: skipTeamsEventsScreen(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator();
                  }
                  List<dynamic> res = snapshot.data as List<dynamic>;
                  return IconButton(
                      icon: Icon(Icons.checklist),
                      iconSize: 50,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return res[0] as bool
                              ? TeamGames(teamID: teamNumber, eventKey: res[1])
                              : TeamEvents(
                                  teamID: teamNumber,
                                );
                        }));
                      });
                }),
          ],
        )));
  }

  Future<List<dynamic>> skipTeamsEventsScreen() async {
    Map<String, String> selectedEvents =
        await Database.instance.getSelectedEvents();

    bool skip = selectedEvents.length == 1;
    String key = selectedEvents.keys.first;
    return [skip, key];
  }
}
