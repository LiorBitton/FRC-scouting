import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AnalysisHome extends StatefulWidget {
  AnalysisHome({Key? key}) : super(key: key);

  @override
  _AnalysisHomeState createState() => _AnalysisHomeState();
}

class _AnalysisHomeState extends State<AnalysisHome> {
  List<bool> _isOpen = [];
  @override
  Widget build(BuildContext context) async {
    return Scaffold(
        appBar: AppBar(title: Text('Stats')),
        body: Column(
          children: [
            ExpansionPanelList(
              animationDuration: Duration(milliseconds: 600),
              children: FutureBuilder<ExpansionPanel>(builder: ,) ,
              expansionCallback: (i, isOpen) {
                setState(() {
                  _isOpen[i] = !isOpen;
                });
              },
            ),
          ],
        ));
  }

  Future<List<ExpansionPanel>> getStuff() async {
    List<String> teams = await test();
    List<ExpansionPanel> res = [];
    for (int i = 0; i < teams.length; i++) {
      _isOpen.add(true);
      res.add(ExpansionPanel(
          headerBuilder: (context, isOpen) {
            return Row(
              children: [
                SizedBox(width: 5, height: 5),
                Text(teams[i],
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            );
          },
          isExpanded: _isOpen[i],
          body: FloatingActionButton(
            onPressed: () {},
          )));
    }
    return res;
  }

  Future<List<String>> test() async {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    final DatabaseReference ref =
        database.reference().child('teams').child('m_teams');
    List<String> teams = [];
    DataSnapshot? res =await ref.get();
    for(var val in res?.value.values)
      teams.add(val.toString());
    return teams;
  }
}
