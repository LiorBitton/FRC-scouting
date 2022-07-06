import 'package:flutter/material.dart';

class TeamStats extends StatelessWidget {
  const TeamStats({Key? key, required this.teamID}) : super(key: key);
  final String teamID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Team $teamID - Stats")),
      // body: CategoryList(data: ["okay", "cool", "wow🎈"], title: "stats"),
    );
  }
}
