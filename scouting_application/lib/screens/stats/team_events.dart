import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/screens/stats/team_games.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class TeamEvents extends StatelessWidget {
  TeamEvents({Key? key, required this.teamID, required this.events})
      : super(key: key);
  final String teamID;
  final Map<String, String> events;

  @override
  Widget build(BuildContext context) {
    for (String event in events.keys) {
      Database.instance.updateEventConsistency(teamID, event);
    }
    return Scaffold(
        appBar: AppBar(title: Text("Team $teamID Events")),
        body: ListView.separated(
          itemCount: events.length,
          itemBuilder: ((context, index) {
            String key = events.keys.elementAt(index);
            String name = events[key]!;
            return ListTile(
              title: Text(name),
              subtitle: Text(key),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeamGames(
                              teamID: teamID,
                              eventKey: key,
                            )));
              },
            );
          }),
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: CustomTheme.teamColor, // Colors.black,
              thickness: 3,
            );
          },
        ));
  }
}
