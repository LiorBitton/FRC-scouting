import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/secret_constants.dart';
import 'package:scouting_application/screens/admin_choose_teams.dart';
import 'package:scouting_application/screens/stats/stats_lobby.dart';
import 'package:scouting_application/themes/custom_themes.dart';
import 'package:settings_ui/settings_ui.dart';

class AdminSettings extends StatefulWidget {
  AdminSettings({Key? key}) : super(key: key);

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  String currentEventValue = Global.current_event;
  bool _allowFreeScouting = Global.allowFreeScouting;
  late Future<List<DropdownMenuItem<String>>> futureEvents;
  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
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
                        value: currentEventValue,
                        items: snapshot.data!,
                        onChanged: (val) {
                          setState(() {
                            currentEventValue = val.toString();
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
    _updatedbValues();
    Global.current_event = currentEventValue;
    Global.allowFreeScouting = _allowFreeScouting;
  }

  void _updatedbValues() {
    FirebaseDatabase.instance
        .ref('settings/current_event')
        .set(currentEventValue);
    FirebaseDatabase.instance
        .ref('settings/allow_free_scouting')
        .set(_allowFreeScouting);
  }

  void removeFromDatabase(List<String> teams) {
    //todo implement
  }
  void _handleBlockTeams() async {
    List<String> teams = await StatsLobby.fetchTeamsInCurrentEvent();
    List<String> currentlyBlockedTeams = await _fetchBlockedTeams();
    _hideFromRealtimeScouting(
      await selectTeams(teams, alreadySelected: currentlyBlockedTeams),
    );
  }

  Future<List<String>> _fetchBlockedTeams() async {
    final blockedTeamsRef =
        FirebaseDatabase.instance.ref('settings/blocked_teams');
    blockedTeamsRef.keepSynced(true);
    final DataSnapshot blockedTeamsData = await blockedTeamsRef.get();
    List<String> blockedList = [];
    if (blockedTeamsData.exists) {
      final List<dynamic> tempBlockedList = blockedTeamsData.value as List;

      for (var item in tempBlockedList) {
        blockedList.add(item.toString());
      }
    }
    return blockedList;
  }

  void _hideFromRealtimeScouting(List<String> teams) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("settings/blocked_teams");
    try {
      await ref.remove();
    } catch (e) {}
    await ref.set(teams);
  }

  Future<List<DropdownMenuItem<String>>> fetchEvents() async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/district/${year}isr/events/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
    List<DropdownMenuItem<String>> out = [];
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      for (var event in res) {
        String name = (event as Map<String, dynamic>)['name'];
        String id = event['key'];
        out.add(DropdownMenuItem(value: id, child: Text(name)));
      }
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
