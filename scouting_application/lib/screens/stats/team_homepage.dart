import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/screens/stats/team_events.dart';
import 'package:scouting_application/screens/stats/team_games.dart';
import 'package:scouting_application/screens/stats/team_photo_gallery.dart';
import 'package:scouting_application/widgets/menu_button.dart';

// ignore: must_be_immutable
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
  Map<String, String> events = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Team $teamNumber")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            SizedBox(height: 100),
            // MenuButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => TeamStats(teamID: teamNumber)));
            //     },
            //     isPrimary: true,
            //     icon: Icon(Icons.auto_graph_rounded)),
            // SizedBox(height: 100),
            FutureBuilder(
                future: loadTeamsValidEvents(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<dynamic> res = snapshot.data as List<dynamic>;
                  return MenuButton(
                    icon: Icon(Icons.checklist),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return res[0] as bool
                            ? TeamGames(teamID: teamNumber, eventKey: res[1])
                            : TeamEvents(
                                teamID: teamNumber,
                                events: events,
                              );
                      }));
                    },
                    isPrimary: false,
                  );
                }),
            SizedBox(height: 40),
            MenuButton(
              icon: Icon(Icons.image_search),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeamPhotoGallery(
                              teamNumber: teamNumber,
                            )));
              },
              isPrimary: false,
            ),
          ],
        )));
  }

  Future<List<dynamic>> loadTeamsValidEvents() async {
    final Map<String, String> selectedEvents =
        await Database.instance.getSelectedEvents();
    List<String> recordedEvents =
        await Database.instance.getTeamsRecordedEventsKeys(teamNumber);
    Map<String, String> validEvents = {};
    for (String eventKey in recordedEvents) {
      if (selectedEvents.keys.contains(eventKey)) {
        validEvents.putIfAbsent(eventKey, () => selectedEvents[eventKey]!);
      }
    }
    events = validEvents;
    for (String event in validEvents.keys) {
      Database.instance.updateEventConsistency(teamNumber, event);
    }
    bool skip = validEvents.length == 1;
    String key = validEvents.keys.first;
    return [skip, key];
  }
}
