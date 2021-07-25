import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class AnalysisHome extends StatefulWidget {
  AnalysisHome({Key? key}) : super(key: key);

  @override
  _AnalysisHomeState createState() => _AnalysisHomeState();
}

class _AnalysisHomeState extends State<AnalysisHome> {
  List<bool> _isOpen = [];
  List<String> teams = [];
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
                return Text('loading');
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
        body: Text('TO DO - add stats display'),
      ));
    }
    return res;
  }

  Future<List<String>> getTeams() async {
    firebase_core.Firebase.initializeApp();
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    List<String> teams = [];
    teams = await ref
        .child("teams")
        .child('m_teams')
        .once()
        .then((DataSnapshot data) {
      int length = data.key?.length ?? 0;
      for (int i = 0; i < length; i++) {
        teams.add(data.value[i]['id'].toString());
      }
      return teams;
    });
    print(teams.toString());
    return teams;
  }
}
