import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_general.dart';
import 'package:scouting_application/screens/scouting/scout_pregame.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class ScoutLobby extends StatelessWidget {
  const ScoutLobby({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Scouting')),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MenuButton(
                  title: 'game',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoutPregame()));
                  },
                ),
                SizedBox(
                  height: 5,
                  width: 5,
                ),
                MenuButton(
                  title: 'general',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoutGeneral()));
                  },
                )
              ]),
        ));
  }
}

// class MenuButton extends StatelessWidget {
//   const MenuButton({Key? key, required this.title, required this.onPressed})
//       : super(key: key);
//   final String title;
//   final void Function()? onPressed;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 50,
//         width: 100,
//         child: FloatingActionButton(
//           onPressed: onPressed,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Text(
//             '$title',
//             style: TextStyle(fontSize: 20.0),
//             maxLines: 1,
//           ),
//         ));
//   }
// }
