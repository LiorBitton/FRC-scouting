import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/secret_constants.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/screens/scouting/game_manager.dart';

class RealtimeScoutingLobby extends StatefulWidget {
  RealtimeScoutingLobby({Key? key}) : super(key: key);

  @override
  State<RealtimeScoutingLobby> createState() => _RealtimeScoutingLobbyState();
}

class _RealtimeScoutingLobbyState extends State<RealtimeScoutingLobby> {
  late Future<Wrap> futureMatches;

  @override
  Widget build(BuildContext context) {
    futureMatches = createUI();
    return Scaffold(
        appBar: AppBar(title: Text(Global.current_event)),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<Wrap>(
              future: futureMatches,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  print('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }

  Future<Wrap> createUI() async {
    List<Container> content = [];
    dynamic matches = await fetchMatches();
    for (dynamic match in matches) {
      Map<String, dynamic> tempMatch =
          Map<String, dynamic>.from(match as Map<String, dynamic>);
      content.add(getMatchContainer(tempMatch));
    }
    return Wrap(
      direction: Axis.vertical,
      spacing: 50,
      children: content,
    );
  }

  Container getMatchContainer(Map<String, dynamic> match) {
    List<dynamic> blueAlliance = match['alliances']['blue']['team_keys'];
    List<dynamic> redAlliance = match['alliances']['red']['team_keys'];
    List<ElevatedButton> blueButtons = [];
    List<ElevatedButton> redButtons = [];

    ///
    final String matchNumber = match['match_number'].toString();
    final String matchSet = match['set_number'].toString();
    final String matchType = match['comp_level'];
    final String matchKey = '$matchType${matchSet}m$matchNumber';
    String matchTitle = '';

    ///
    for (int i = 0; i < blueAlliance.length; i++) {
      blueAlliance[i] = (blueAlliance[i] as String).replaceAll('frc', '');
      blueButtons
          .add(getTeamButton(true, blueAlliance[i].toString(), matchKey));
      redAlliance[i] = (redAlliance[i] as String).replaceAll('frc', '');
      redButtons.add(getTeamButton(false, redAlliance[i].toString(), matchKey));
    }

    switch (matchType) {
      case "f":
        matchTitle = "Final $matchNumber";
        break;
      case "sf":
        matchTitle = "SF $matchSet - $matchNumber";
        break;
      case "qf":
        matchTitle = "QF $matchSet - $matchNumber";
        break;
      case "qm":
        matchTitle = "Qual #$matchNumber";
    }
    final double buttonSpacing = 10;
    return Container(
        width: 280,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[100]!,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500]!,
                blurRadius: 10,
                offset: const Offset(4, 4),
                spreadRadius: 1)
          ],
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 30,
                  children: [
                    SizedBox(width: 1),
                    Text(
                      matchTitle,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 38,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //red alliance
                    Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        direction: Axis.vertical,
                        spacing: buttonSpacing, // <-- Spacing between children
                        children: redButtons),
                    //blue alliance
                    Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        direction: Axis.vertical,
                        spacing: buttonSpacing, // <-- Spacing between children
                        children: blueButtons)
                  ])
            ]));
  }

  ElevatedButton getTeamButton(bool isBlue, String teamID, String matchKey) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GameManager(
                      isBlueAll: isBlue,
                      matchKey: matchKey,
                      teamNumber: int.parse(teamID))));
        },
        child: Text(teamID,
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 26)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                isBlue ? Colors.blue : Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ))));
  }

  Future<List<dynamic>> fetchMatches() async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/${Global.current_event}/matches/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
    List<dynamic> res = [];
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
    } else {
      log('error downloading matches');
    }
    return res;
  }
}
