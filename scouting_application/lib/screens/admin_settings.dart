import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/tba_client.dart';
import 'package:scouting_application/screens/admin_choose_teams.dart';
import 'package:scouting_application/themes/custom_themes.dart';
import 'package:settings_ui/settings_ui.dart';

//TODO use TeamData[] instead of teams[]
class AdminSettings extends StatefulWidget {
  AdminSettings({Key? key}) : super(key: key);

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  String currentEventKey = Global.currentEventKey;
  String currentEventName = "";

  ///key = event key; value = event name
  Map<String, String> events = {};
  bool _allowFreeScouting = Global.allowFreeScouting;
  late Future<List<DropdownMenuItem<String>>> futureEvents;
  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureEvents = buildEventsDropdownList();
  }

  void addAdmin(String email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('settings/admins');
    DataSnapshot data = await ref.get();
    List<dynamic> admins = (data.value as List).toList();
    admins.add(email);
    ref.set(admins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.group_add),
              onPressed: () {
                _displayEmailInputDialog(context);
              }),
        ],
      ),
      body: SettingsList(
        sections: [
          SettingsSection(title: const Text("Event"), tiles: [
            SettingsTile(
              title: const Text(
                "Event",
                maxLines: 1,
              ),
              trailing: FutureBuilder<List<DropdownMenuItem<String>>>(
                future: futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButton(
                        iconSize: 0,
                        value: currentEventKey,
                        items: snapshot.data!,
                        onChanged: (val) {
                          setState(() {
                            currentEventKey = val.toString();
                            currentEventName = events[currentEventKey] ?? "";
                          });
                          _saveValues();
                        });
                  } else if (snapshot.hasError) {}
                  return const CircularProgressIndicator();
                },
              ),
            ),
            SettingsTile.switchTile(
                leading: Icon(Icons.event_available),
                initialValue: _allowFreeScouting,
                activeSwitchColor: CustomTheme.teamColor,
                onToggle: (val) {
                  setState(() {
                    _allowFreeScouting = val;
                  });
                  _saveValues();
                },
                title: Text("Allow Free Scouting"))
          ]),
          SettingsSection(title: Text("Database"), tiles: [
            SettingsTile(
                title: Text("Remove Teams"),
                description: Text("Erase team's data."),
                leading: Icon(Icons.delete_sweep),
                onPressed: (_) {
                  // List<String> teamsToRemove = selectTeams();
                  // removeFromDatabase(teamsToRemove); TODO
                }),
            SettingsTile(
                title: Text("Block Teams"),
                description: Text("Hide specific teams from scouters."),
                leading: Icon(Icons.block),
                onPressed: (_) {
                  setState(() {
                    _handleBlockTeams();
                  });
                })
          ])
        ],
      ),
    );
  }

  void _saveValues() {
    Database.instance
        .setCurrentEvent(key: currentEventKey, name: currentEventName);
    Database.instance.setAllowFreeScouting(_allowFreeScouting);
    Global.currentEventKey = currentEventKey;
    Global.currentEventName = currentEventName;
    Global.allowFreeScouting = _allowFreeScouting;
  }

  void removeFromDatabase(List<String> teams) {
    //todo implement
  }
  void _handleBlockTeams() async {
    List<String> teams =
        await TBAClient.instance.fetchTeamsInEvent(currentEventKey);
    List<String> currentlyBlockedTeams =
        await Database.instance.fetchBlockedTeams();
    Database.instance.blockTeamsFromScouting(
      await selectTeams(teams, alreadySelected: currentlyBlockedTeams),
    );
  }

  Future<List<DropdownMenuItem<String>>> buildEventsDropdownList() async {
    events = await TBAClient.instance.fetchIsraelEvents();
    List<DropdownMenuItem<String>> out = [];

    for (var eventKey in events.keys) {
      String name = events[eventKey].toString();
      out.add(DropdownMenuItem(
        value: eventKey,
        child: Text(name),
      ));
    }

    return out;
  }

  String _emailValue = "";
  Future<void> _displayEmailInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Admin's Email"),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _emailValue = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "liorb5000@gmail.com"),
            ),
            actions: [
              IconButton(
                color: Colors.red,
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              IconButton(
                color: Colors.green,
                icon: Icon(Icons.check),
                onPressed: () {
                  setState(() {
                    addAdmin(_emailValue);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<List<String>> selectTeams(List<String> teams,
      {List<String> alreadySelected = const []}) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChooseTeams(teams: teams, alreadySelected: alreadySelected)));

    return result;
  }
}
