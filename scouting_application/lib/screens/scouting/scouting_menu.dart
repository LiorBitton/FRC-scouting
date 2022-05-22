import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/scouting/free_scouting_lobby.dart';
import 'package:scouting_application/screens/scouting/realtime_scouting_lobby.dart';
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
                        isPrimary: true,
                        icon: Icon(Icons.free_cancellation),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FreeScoutingLobby()));
                        },
                      )
                    : Text(""),
                SizedBox(
                  height: 30,
                ),
                MenuButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RealtimeScoutingLobby()));
                    },
                    isPrimary: !Global.instance.allowFreeScouting,
                    icon: Icon(Icons.add_task))
              ]),
        ));
  }
}
