import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:async';
import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:scouting_application/screens/analysis_gallery.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class AnalysisHome extends StatefulWidget {
  AnalysisHome({Key? key}) : super(key: key);

  @override
  _AnalysisHomeState createState() => _AnalysisHomeState();
}

class _AnalysisHomeState extends State<AnalysisHome> {
  List<bool> _isOpen = [];
  List<String> teams = [];
  List<List<String>> teamsData = [];
  late Future<ExpansionPanelList> items;
  @override
  void initState() {
    updateItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Stats')),
        body: SingleChildScrollView(
          child: FutureBuilder<ExpansionPanelList>(
              future: items,
              builder: (BuildContext conte,
                  AsyncSnapshot<ExpansionPanelList> snapshot) {
                if (snapshot.hasData) {
                  return (snapshot.data as Widget);
                }
                return Center(
                  child: CircularProgressIndicator(
                      color: CustomTheme.darkTheme.primaryColor),
                );
              }),
        ));
  }

  void updateItems() async {
    items = createExpansionPanelList();
  }

  Future<ExpansionPanelList> createExpansionPanelList() async {
    List<ExpansionPanel> teams = await createExpansionPanels();
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 600),
      children: teams,
      expansionCallback: (i, isOpen) {
        setState(() {
          _isOpen[i] = !isOpen;
          updateItems();
        });
      },
    );
  }

  Future<List<ExpansionPanel>> createExpansionPanels() async {
    if (teams.isEmpty) {
      teams = await getTeams();
    }
    List<ExpansionPanel> res = [];
    for (int i = 0; i < teams.length; i++) {
      _isOpen.add(false);
      res.add(ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (context, isOpen) {
          return Row(
            children: [
              SizedBox(width: 5, height: 5),
              Text(teams[i],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ],
          );
        },
        isExpanded: _isOpen[i],
        body: Column(
          children: [
            TeamDataWidget(dataToShow: teamsData[i]),
            FloatingActionButton(
                heroTag: new Random().nextInt(99999),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AnalysisGallery(teamID: teams[i])));
                }),
            FittedBox(
              fit: BoxFit.cover,
              child: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    final fb = FirebaseDatabase.instance;
                    final ref = fb.reference();
                    final listenerRef =
                        ref.child('listeners').child('update_team_analytics');
                    listenerRef.set(teams[i]);
                    listenerRef.onValue.listen((event) {
                      if(event.snapshot.value=="0"){//it means the operation ended
          Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalysisHome()));
                      }
                    });
                    
                  }),
            )
          ],
        ),
      ));
    }
    return res;
  }

  Future<List<String>> getTeams() async {
    firebase_core.Firebase.initializeApp();
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    List<String> teams = [];
    teams = await ref.child("teams").once().then((DataSnapshot data) async {
      final info = Map<String, dynamic>.from(data.value);
      List<String> teamNumbers = [];
      for (var teamID in info.keys) {
        teamNumbers.add(teamID);
        List<String> teamData = [];
        try {
          //add the data from teams/teamID/stats
          final stats = Map<String, dynamic>.from(info[teamID]['stats']);
          for (var key in stats.keys) {
            teamData.add('$key:${stats[key]}');
          }
          teamData.add('===DATA FROM LAST GAME===');
          //add the data from teams/teamID/last_game
          final lastGame = Map<String, dynamic>.from(info[teamID]['last_game']);
          for (var key in lastGame.keys) {
            teamData.add('$key:${lastGame[key]}');
          }
        } catch (Exception) {
          teamData.add('no statistics for this team yet');
        }
        teamsData.add(teamData);
      }
      return teamNumbers;
    });
    return teams;
  }
}

class TeamDataWidget extends StatelessWidget {
  // ignore: non_constant_identifier_names
  const TeamDataWidget({Key? key, required this.dataToShow}) : super(key: key);
  //lg_ stands for last game, used before the team's last game data
  final List<String> dataToShow;
  List<Widget> _create() {
    List<Text> res = [];
    for (String item in dataToShow) {
      res.add(Text(item));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 5,
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _create(),
            ),
          ],
        ),
        SizedBox(
          width: 5,
          height: 5,
        ),
      ],
    );
  }
}
