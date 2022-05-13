import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/scouting/realtime_scouting_lobby.dart';
import 'package:scouting_application/screens/scouting/free_scouting_lobby.dart';
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
                        title: 'Free',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FreeScoutingLobby()));
                        },
                      )
                    : Text(""),
                SizedBox(
                  height: 5,
                  width: 5,
                ),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.add_task),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RealtimeScoutingLobby()));
                  },
                ),
                SizedBox(
                  height: 5,
                  width: 5,
                ),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.add_photo_alternate),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ScoutGeneral()));
                  },
                )
              ]),
        ));
  }
}
