import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/tba_client.dart';
import 'package:scouting_application/screens/scouting/game_manager.dart';

class RealtimeScouting extends StatefulWidget {
  RealtimeScouting({Key? key}) : super(key: key);

  @override
  State<RealtimeScouting> createState() => _RealtimeScoutingState();
}

class _RealtimeScoutingState extends State<RealtimeScouting> {
  late Future<Wrap> futureMatches;
  bool isDarkMode = false;

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
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
          title: Text(Global.instance.currentEventName.replaceAll("FIRST", "")),
          floating: true,
          stretch: true),
      StreamBuilder<dynamic>(
          stream: Database.instance.getScoutedTeamsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              hiddenTeams.clear();
              hiddenTeams.addAll(blockedTeams);
              hiddenTeams.addAll(snapshot.data);
            }
            return FutureBuilder<SliverList>(
              future: createUI(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  print('${snapshot.error}');
                }
                return SliverList(
                    delegate: SliverChildBuilderDelegate(((context, index) {
                  if (index == 0)
                    return Container(child: LinearProgressIndicator());
                  return Container(child: Text(""));
                })));
              },
            );
          })
    ]));
  }

  Future<void> initBlockedTeams() async {
    List<String> tempBlockedTeams = await Database.instance.fetchBlockedTeams();
    blockedTeams.addAll(tempBlockedTeams);
  }

  Future<SliverList> createUI() async {
    List<Container> content = [];
    dynamic matches;
    try {
      matches = await TBAClient.instance
          .fetchMatchesByEvent(Global.instance.currentEventKey);
    } catch (e, s) {
      Database.instance.recordError(e, s);
      Global.instance.allowFreeScouting = true;
      matches = [];
    }
    if ((matches as List<dynamic>).contains(0)) {
      //handle no matches
      Database.instance.log("Matches are not posted yet, notifying user.");
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          ((context, index) {
            return Center(child: const Text("Matches are not posted yet."));
          }),
          childCount: 1,
        ),
      );
    }
    if ((matches).contains(1)) {
      //handle connection problem
      Database.instance
          .log("Connection problem fetching event matches, notifying user.");
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          ((context, index) {
            return Center(
                child:
                    const Text("Connection problem fetching event matches."));
          }),
          childCount: 1,
        ),
      );
    }
    (matches).sort((a, b) {
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
    if (matches.isEmpty) {
      Database.instance.log("event matches have ended, notifying user");
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          ((context, index) {
            return Text("Event ended, contact admin if this is a mistake.");
          }),
          childCount: 1,
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        ((context, index) {
          return content[index];
        }),
        childCount: content.length,
      ),
    );
  }

  Container? getMatchContainer(Map<String, dynamic> match) {
    if ((match["alliances"]["red"]["score"] != null && //Red team has scored
            match["alliances"]["red"]["score"] >= 0) ||
        (match["alliances"]["blue"]["score"] != null && //Blue team has scored
            match["alliances"]["blue"]["score"] >= 0))
      return null; //dont show match if already played
    List<dynamic> blueAlliance = match['alliances']['blue']['team_keys'];
    List<dynamic> redAlliance = match['alliances']['red']['team_keys'];
    List<TeamButton> blueButtons = [];
    List<TeamButton> redButtons = [];

    ///
    final String matchNumber = match['match_number'].toString();
    final String matchSet = match['set_number'].toString();
    final String matchType = match['comp_level'];
    final String matchKey = '$matchType${matchSet}m$matchNumber';
    String matchTitle = '';

    ///
    for (int i = 0; i < blueAlliance.length; i++) {
      blueAlliance[i] = (blueAlliance[i] as String).replaceAll('frc', '');
      TeamButton bluebtn =
          getTeamButton(true, blueAlliance[i].toString(), matchKey);
      blueButtons.add(bluebtn);
      redAlliance[i] = (redAlliance[i] as String).replaceAll('frc', '');
      TeamButton redbtn =
          getTeamButton(false, redAlliance[i].toString(), matchKey);
      redButtons.add(redbtn);
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
    MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsetsDirectional.fromSTEB(50, 20, 50, 20),
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isDarkMode ? Colors.grey[900]! : Colors.white24,
          boxShadow: [
            BoxShadow(
                //bottom shadow
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[600]!,
                blurRadius: isDarkMode ? 2 : 15,
                offset: const Offset(4, 4),
                spreadRadius: isDarkMode ? 0.01 : 1),
            BoxShadow(
                //top shadow
                color: isDarkMode ? Colors.grey[400]! : Colors.white,
                blurRadius: isDarkMode ? 0 : 02,
                offset: const Offset(-4, -4),
                spreadRadius: isDarkMode ? 0.03 : 1)
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
                          color: isDarkMode ? Colors.grey[300] : Colors.black,
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

  TeamButton getTeamButton(bool isBlue, String teamID, String matchKey) {
    return TeamButton(
        isBlue: isBlue,
        teamID: teamID,
        matchKey: matchKey,
        isActivated: !hiddenTeams.contains(teamID));
  }
}

class TeamButton extends StatelessWidget {
  const TeamButton(
      {Key? key,
      required this.isBlue,
      required this.teamID,
      required this.matchKey,
      this.isActivated})
      : super(key: key);
  final bool isBlue;
  final String teamID;
  final String matchKey;
  final isActivated;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isActivated
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameManager(
                            isBlueAll: isBlue,
                            matchKey: matchKey,
                            teamNumber: int.parse(teamID))));
              }
            : null,
        child: Text(teamID,
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 26)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(isActivated
                ? (isBlue ? Colors.blue : Colors.red)
                : Colors.grey[700]!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ))));
  }
}
