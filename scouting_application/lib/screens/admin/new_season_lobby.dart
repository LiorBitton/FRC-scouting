import 'package:flutter/material.dart';
import 'package:scouting_application/screens/admin/edit_tab.dart';

class NewSeasonLobby extends StatelessWidget {
  const NewSeasonLobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber)),
                child: Text(
                  "Create Auton",
                  maxLines: 1,
                ),
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTab(
                                tabName: "Autonomous",
                              )));
                })),
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber)),
                child: Text(
                  "Create Teleop",
                  maxLines: 1,
                ),
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTab(
                                tabName: "Teleop",
                              )));
                })),
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber)),
                child: Text(
                  "Create Endgame",
                ),
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTab(
                                tabName: "Endgame",
                              )));
                })),
            // Spacer(),
            // CountCollector(title: "Count", dataTag: "Count"),
            // DropDownCollector(
            //     dataTag: "dropDown",
            //     options: ["option 1", "option2", "option3"],
            //     title: "Dropdown"),
            // PlusMinusCollector(title: "Plus Minus", dataTag: "Plus Minus"),
            // SwitchCollector(title: "Switch", dataTag: "Switch"),
            // DurationCollector(title: "Duration", dataTag: "duration"),
            // TextCollector(
            //     title: "title", dataTag: "text", hintText: "Free Text"),
            // Spacer()
          ],
        ));
  }
}
