import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class GameData extends StatelessWidget {
  const GameData({Key? key, required this.teamID, required this.data})
      : super(key: key);
  final String teamID;
  final Map<String, dynamic> data;
  @override //todo generic display for data
  Widget build(BuildContext context) {
    final List<String> dataKeys = data.keys.toList();
    List<String> autoKeys = [];
    List<String> teleKeys = [];
    List<String> endKeys = [];
    List<String> genKeys = [];
    for (String key in dataKeys) {
      String valName = key.split("_")[1];
      switch (key.substring(0, 2)) {
        case "au":
          autoKeys.add("$valName : ${data[key]}");
          break;
        case "te":
          teleKeys.add("$valName : ${data[key]}");
          break;
        case "en":
          endKeys.add("$valName : ${data[key]}");
          break;
        case "ge":
          genKeys.add("$valName : ${data[key]}");
          break;
      }
    }
    return Scaffold(
        appBar: AppBar(title: Text("Team $teamID game")),
        body: ListView(
          children: [
            CategoryList(data: autoKeys, title: "Autonomous"),
            CategoryList(data: teleKeys, title: "Teleop"),
            CategoryList(data: endKeys, title: "Endgame"),
            CategoryList(data: genKeys, title: "General"),
          ],
        ));
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);
  final String title;
  final List<String> data;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 0),
          child: Wrap(children: [
            Text(title,
                textScaleFactor: 2,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                )),
            const Divider(
              color: CustomTheme.teamColor,
              thickness: 1,
              endIndent: 200,
            )
          ]),
        ),
        for (String item in data)
          Wrap(children: [
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  item,
                  textScaleFactor: 1.2,
                ),
              ],
            ),
            const Divider(
              color: CustomTheme.teamColor, // Colors.black,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            )
          ])
      ],
    );
  }
}
