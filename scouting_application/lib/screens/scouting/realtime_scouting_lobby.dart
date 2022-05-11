import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/tba_client.dart';
import 'package:scouting_application/screens/scouting/game_manager.dart';

class RealtimeScoutingLobby extends StatefulWidget {
  RealtimeScoutingLobby({Key? key}) : super(key: key);

  @override
  State<RealtimeScoutingLobby> createState() => _RealtimeScoutingLobbyState();
}

class _RealtimeScoutingLobbyState extends State<RealtimeScoutingLobby> {
  late Future<Wrap> futureMatches;

  ///Teams that either being scouted at the moment or were chosen to be hidden by admin
  Set<String> hiddenTeams = new Set<String>();
  Set<String> blockedTeams = new Set<String>();
  @override
  void initState() {
    super.initState();
    initBlockedTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Global.currentEventName)),
        body: SingleChildScrollView(
          child: Center(
            child: StreamBuilder<dynamic>(
                stream: scoutedTeamsRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    hiddenTeams.clear();
                    hiddenTeams.addAll(blockedTeams);
                    if (((snapshot.data as DatabaseEvent).snapshot.value) !=
                        null) {
                      Map<String, dynamic> val = Map<String, dynamic>.from(
                          ((snapshot.data as DatabaseEvent).snapshot.value)
                              as Map<dynamic, dynamic>);

                      hiddenTeams.addAll(val.keys.toList());
                    }
                  }
                  return FutureBuilder<Wrap>(
                    future: createUI(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else if (snapshot.hasError) {
                        print('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                }),
          ),
        ));
  }

  

  Future<void> initBlockedTeams() async {
    List<String> tempBlockedTeams = await Database.instance.fetchBlockedTeams();
    blockedTeams.addAll(tempBlockedTeams);
  }

  Future<Wrap> createUI() async {
    List<Container> content = [];
    dynamic matches =
        await TBAClient.instance.fetchMatchesByEvent(Global.currentEventKey);

    (matches as List<dynamic>).sort((a, b) {
      //yyyy[EVENT_CODE]_[COMP_LEVEL]m[MATCH_NUMBER]
      String aKey = a["key"];
      String bKey = b["key"];

      int stageEqual = aKey // _[COMP_LEVEL]m
          .substring(aKey.indexOf("_"), aKey.lastIndexOf("m"))
          .compareTo(bKey.substring(bKey.indexOf("_"), bKey.lastIndexOf("m")));
      if (stageEqual != 0) {
        return stageEqual;
      }

      return a["match_number"] - b["match_number"]; //[MATCH_NUMBER]
    });
    for (dynamic match in matches) {
      Map<String, dynamic> tempMatch =
          Map<String, dynamic>.from(match as Map<String, dynamic>);
      Container? matchCont = getMatchContainer(tempMatch);
      if (matchCont != null) content.add(matchCont);
    }
    return Wrap(
      direction: Axis.vertical,
      spacing: 50,
      children: content,
    );
  }

  Container? getMatchContainer(Map<String, dynamic> match) {
    // if (match["winning_alliance"] != "" &&
    //     (match["alliances"]["red"]["score"] == -1 ||
    //         match["alliances"]["red"]["score"] == null))
    //   return null; //dont show match if already played
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
      ElevatedButton? bluebtn =
          getTeamButton(true, blueAlliance[i].toString(), matchKey);
      if (bluebtn != null) blueButtons.add(bluebtn);
      redAlliance[i] = (redAlliance[i] as String).replaceAll('frc', '');
      ElevatedButton? redbtn =
          getTeamButton(false, redAlliance[i].toString(), matchKey);
      if (redbtn != null) redButtons.add(redbtn);
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

  ElevatedButton? getTeamButton(bool isBlue, String teamID, String matchKey) {
    return hiddenTeams.contains(teamID)
        ? null
        : ElevatedButton(
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
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700, fontSize: 26)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    isBlue ? Colors.blue : Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ))));
  }
}
