import 'package:flutter/material.dart';
import 'package:scouting_application/screens/admin/edit_auto.dart';
import 'package:scouting_application/widgets/collectors/count_collector.dart';
import 'package:scouting_application/widgets/collectors/dropdown_collector.dart';
import 'package:scouting_application/widgets/collectors/duration_collector.dart';
import 'package:scouting_application/widgets/collectors/plus_minus_collector.dart';
import 'package:scouting_application/widgets/collectors/switch_collector.dart';
import 'package:scouting_application/widgets/collectors/text_collector.dart';

class NewSeasonLobby extends StatelessWidget {
  const NewSeasonLobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            IconButton(
                icon: Icon(Icons.abc),
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAutonomous()));
                })),
            CountCollector(title: "test", dataTag: "Count"),
            DropDownCollector(
                dataTag: "dropDown",
                options: ["option 1", "option2", "option3"],
                title: "Dropdown"),
            PlusMinusCollector(title: "plus minus", dataTag: "Plus Minus"),
            SwitchCollector(title: "Switch", dataTag: "Switch"),
            DurationCollector(dataTag: "duration"),
            TextCollector(dataTag: "text", hintText: "Free Text")
          ],
        ));
  }
}
