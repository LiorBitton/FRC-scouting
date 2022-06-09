import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/screens/stats/team_events.dart';
import 'package:scouting_application/screens/stats/team_games.dart';
import 'package:scouting_application/screens/stats/team_photo_gallery.dart';

class TeamHomepage extends StatelessWidget {
  TeamHomepage(
      {Key? key,
      required this.teamNumber,
      required this.teamAvatar,
      required this.teamName})
      : super(key: key);
  final String teamNumber;
  final String teamName;
  final Widget? teamAvatar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Team $teamNumber")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20),
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                teamAvatar ?? Container(),
                Text(
                  teamName,
                  maxLines: 3,
                  softWrap: true,
                  style: GoogleFonts.acme(fontSize: 25, color: Colors.white),
                  textScaleFactor: 2,
                )
              ],
            ),
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
                    return CircularProgressIndicator();
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
