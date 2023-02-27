import 'package:flutter/material.dart';

class TeamStats extends StatelessWidget {
  const TeamStats({Key? key, required this.teamID}) : super(key: key);
  final String teamID;
  @override
  Widget build(BuildContext context) {
    final FirebaseDatabase db = FirebaseDatabase.instance;
    db.ref("teams/$teamID/${Global.currentEventKey}/custom").get;
    DataSnapshot snapshot = await db
        .ref("teams/$teamID/${Global.currentEventKey}/custom")
        .get()
        .timeout(Duration(seconds: 5));
    if (!snapshot.exists) {
      return {};
    }
    Map<String, dynamic> data = Map<String, dynamic>.from(
        snapshot.value as Map<dynamic, dynamic>);
    List<Map<String,String>> keys = [];
    for(MapEntry<String, dynamic> entry in data.entries){
      keys.append({entry.key:entry.value.toString()});
    }
    return Scaffold(
      appBar: AppBar(title: Text("Team $teamID - Stats")),
      body: CategoryList(data: keys, title: "stats"),
    );
  }
}
