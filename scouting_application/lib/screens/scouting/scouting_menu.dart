import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/scouting/free_scouting.dart';
import 'package:scouting_application/screens/scouting/realtime_scouting.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class ScoutingMenu extends StatelessWidget {
  const ScoutingMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Scouting')),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Global.instance.allowFreeScouting
                    ? MenuButton(
                        iconSize: MenuButton.MENU_SIZE,
                        isPrimary: true,
                        icon: Icon(Icons.free_cancellation),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FreeScouting()));
                        },
                      )
                    : Text(""),
                SizedBox(
                  height: 30,
                ),
                MenuButton(
                    iconSize: MenuButton.MENU_SIZE,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RealtimeScouting()));
                    },
                    isPrimary: !Global.instance.allowFreeScouting,
                    icon: Icon(Icons.add_task))
              ]),
        ));
  }
}
