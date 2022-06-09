import 'package:flutter/material.dart';
import 'package:scouting_application/screens/admin/edit_tab.dart';
import 'package:scouting_application/widgets/menu_text_button.dart';

class NewSeasonLobby extends StatelessWidget {
  const NewSeasonLobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Create New Tabs")),
        body: Center(
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              MenuTextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTab(
                                  tabName: "Autonomous",
                                )));
                  },
                  text: "Autonomous"),
              MenuTextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTab(
                                  tabName: "Teleop",
                                )));
                  },
                  text: "Teleop"),
              MenuTextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTab(
                                  tabName: "Endgame",
                                )));
                  },
                  text: "Endgame"),
              MenuTextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTab(
                                  tabName: "General",
                                )));
                  },
                  text: "General"),
            ],
          ),
        ));
  }
}
