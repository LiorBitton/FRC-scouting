import 'dart:ui';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/screens/analysis_home.dart';
import 'package:scouting_application/screens/scouting/scout_lobby.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          height: 50,
        ),
        Center(
            child: Text(
          'EverScout',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        )),
        Expanded(
          child: Image.asset(
            'assets/eg_logo_white.png',
            height: 200,
          ),
        ),
        Expanded(
            child: Column(
          children: [
            MenuButton(
              title: 'scout',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScoutLobby()));
              },
            ),
            SizedBox(height: 5, width: 5),
            MenuButton(
              title: 'analysis',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnalysisHome()));
              },
            ),
          ],
        )),
        // FloatingActionButton(onPressed: () {
        //   firebase_core.Firebase.initializeApp();
        //   final fb = FirebaseDatabase.instance;
        //   final ref = fb.reference();
        //   ref.child('cool').set('gh');
        // })
      ]),
    ));
  }
}
