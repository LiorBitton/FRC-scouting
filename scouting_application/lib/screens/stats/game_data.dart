import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class GameData extends StatelessWidget {
  const GameData(
      {Key? key,
      required this.teamID,
      required this.data,
      required this.consistency,
      required this.avgs})
      : super(key: key);
  final String teamID;
  final Map<String, dynamic> data;
  final Map<String, dynamic> consistency;
  final Map<String, dynamic> avgs;
  @override
  Widget build(BuildContext context) {
    final List<String> dataKeys = data.keys.toList();
    List<Map<String, String?>> autoKeys = [];
    List<Map<String, String?>> teleKeys = [];
    List<Map<String, String?>> endKeys = [];
    List<Map<String, String?>> genKeys = [];
    for (String key in dataKeys) {
      if (key == "bluAll") continue;
      final String valName = key.split("_")[1];
      String textValue = "";
      if (data[key].runtimeType == false.runtimeType) {
        assert(data[key].runtimeType == false.runtimeType);
        textValue = data[key] ? "✔" : "✘";
      } else {
        textValue = data[key].toString();
      }
      final String dataToShow = "$valName : $textValue";
      Map<String, String?> keyData = {
        dataToShow: "${avgs[key] ?? ""} | ${consistency[key] ?? ""}"
      };
      if (avgs[key] == null && consistency[key] == null) {
        keyData = {dataToShow: ""};
      }
      switch (key.substring(0, 2)) {
        case "au":
          autoKeys.add(keyData);
          break;
        case "te":
          teleKeys.add(keyData);
          break;
        case "en":
          endKeys.add(keyData);
          break;
        case "ge":
          genKeys.add(keyData);
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
  final List<Map<String, String?>> data;
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
        for (Map<String, String?> item in data)
          Wrap(children: [
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  item.keys.first,
                  textScaleFactor: 1.2,
                ),
                Spacer(),
                Text(item.values.first ?? "",
                    style: TextStyle(overflow: TextOverflow.ellipsis)),
                SizedBox(
                  width: 10,
                )
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
