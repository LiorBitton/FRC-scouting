import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/screens/stats/team_games.dart';

class TeamEvents extends StatelessWidget {
  TeamEvents({Key? key, required this.teamID}) : super(key: key);
  final String teamID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Team $teamID Events")),
        body: FutureBuilder<Map<String, String>>(
            future: _getEvents(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LinearProgressIndicator();
              }
              if (snapshot.data!.isEmpty) {
                return Center(child: Text("There is no data for team $teamID"));
              }
              Map<String, String> events =
                  Map<String, String>.from(snapshot.data!);
              if (events.length == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeamGames(
                            teamID: teamID, eventKey: events.keys.first)));
              }
              return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: ((context, index) {
                    String key = events.keys.elementAt(index);
                    String name = events[key].toString();
                    return ListTile(
                      title: Text(name),
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
                  }));
            }));
  }

  Future<Map<String, String>> _getEvents() async {
    final Map<String, String> selectedEvents =
        await Database.instance.getSelectedEvents();
    List<String> recordedEvents =
        await Database.instance.getTeamsRecordedEventsKeys(teamID);
    Map<String, String> out = {};
    for (String eventKey in recordedEvents) {
      if (selectedEvents.keys.contains(eventKey)) {
        out.putIfAbsent(eventKey, () => selectedEvents[eventKey].toString());
      }
    }
    return out;
  }
}
