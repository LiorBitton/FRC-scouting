import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:async';
import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
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
            FittedBox(fit: BoxFit.cover ,
              child: IconButton(icon:Icon(Icons.refresh),
              // FloatingActionButton(
                  // child: Text('Request update',maxLines: 2,),
                  onPressed: () {
                    final fb = FirebaseDatabase.instance;
                    final ref = fb.reference();
                    final listener_ref =
                        ref.child('listeners').child('update_team_analytics');
                    listener_ref.set(teams[i]);
                    Navigator.pop(context);
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnalysisHome()));
                  }),
            ) //await getTeamData(teams[i])),
            // IconButton( TODO
            //     onPressed: () async {
            //       await _downloadFile(firebase_storage.FirebaseStorage.instance
            //           .ref('teams')
            //           .child(teams[i]));
            //     },
            //     icon: Icon(Icons.photo_album))
          ],
        ),
      ));
    }
    return res;
  }

//TODO
  Future<void> _downloadFile(firebase_storage.Reference ref) async {
    final io.Directory systemTempDir = io.Directory.systemTemp;
    final io.File tempFile = io.File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
          'at path: ${ref.fullPath} \n'
          'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
        ),
      ),
    );
  }

  Future<List<String>> getTeams() async {
    firebase_core.Firebase.initializeApp();
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    List<String> teams = [];
    teams = await ref.child("teams").once().then((DataSnapshot data) {
      final info = Map<String, dynamic>.from(data.value);
      List<String> out = [];
      for (var key in info.keys) {
        out.add(key);
      }

      return out;
    });
    for (var team in teams) {
      teamsData.add(await getTeamData(team));
    }
    return teams;
  }

  Future<List<String>> getTeamData(String teamID) async {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    final team_ref = ref.child('teams').child(teamID);
    final stats_ref = team_ref.child('stats');
    final last_game_ref = team_ref.child('last_game');
    List<String> res = [];
    try {
      res.addAll(await stats_ref.once().then((DataSnapshot data) {
        List<String> out = [];
        final stats = Map<String, dynamic>.from(data.value);
        for (var key in stats.keys) {
          out.add('$key:${stats[key]}');
        }
        return out;
      }));
      res.add('===DATA FROM LAST GAME===');
      res.addAll(await last_game_ref.once().then((DataSnapshot data) {
        List<String> out = [];
        final stats = Map<String, dynamic>.from(data.value);
        for (var key in stats.keys) {
          out.add('$key:${stats[key]}');
        }
        return out;
      }));
    } catch (Exception) {
      return ['Ask the coach to update the analytics'];
    }
    return res;
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
