import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_general.dart';
import 'package:scouting_application/screens/scouting/scout_pregame.dart';

class ScoutLobby extends StatelessWidget {
  const ScoutLobby({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Scouting')),
        body: Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          height: 50,
        ),

        Expanded(
            child: Column(
          children: [
            MenuButton(
              title: 'game',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScoutPregame()));
              },
            ),
            MenuButton(
              title: 'general',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScoutGeneral()));
              },
            ),
          ],
        ))
      ]),
    ));
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);
  final String title;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 20.0),
            maxLines: 1,
          ),
        ));
  }
}
