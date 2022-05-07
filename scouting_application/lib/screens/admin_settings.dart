import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/secret_constants.dart';
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

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () {
              //todo add an admin by email
            },
          ),
        ],
      ),
      body: SettingsList(
        sections: [
          SettingsSection(title: Text("Event"), tiles: [
            SettingsTile(
              title: Text(
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
                leading: Icon(Icons.delete_sweep)
                //todo onPressed: () {}
                ),
            SettingsTile(
              title: Text("Block Teams"),
              description: Text("Hide specific teams from scouters."),
              leading: Icon(Icons.block),
              //todo onPressed: () {}
            )
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
}
