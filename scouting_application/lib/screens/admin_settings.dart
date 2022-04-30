import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/secret_constants.dart';

class AdminSettings extends StatefulWidget {
  AdminSettings({Key? key}) : super(key: key);

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  String currentEventValue = Global.current_event;
  late Future<List<DropdownMenuItem<String>>> futureEvents;
  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Events"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Current Event"),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: futureEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                      value: currentEventValue,
                      items: snapshot.data!,
                      onChanged: (val) {
                        setState(() {
                          currentEventValue = val.toString();
                        });
                      });
                } else if (snapshot.hasError) {
                  print('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              _saveValues();
            },
            icon: Icon(Icons.save))
      ],
    ));
  }

  void _saveValues() {
    _updatedbValues();
    Global.current_event = currentEventValue;
  }

  void _updatedbValues() {
    FirebaseDatabase.instance
        .ref('settings/current_event')
        .set(currentEventValue);
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
