import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/screens/analysis_home.dart';
import 'package:scouting_application/screens/scouting/scout_lobby.dart';

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
            SizedBox(height:5,width: 5),
            MenuButton(
              title: 'analysis',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnalysisHome()));
              },
            ),
            //  ? MenuButton( 
            //     title: "firebase test",
            //     onPressed: () {
            //       final fb = FirebaseDatabase.instance;
            //       final ref = fb.reference();
            //       ref.child('the test').set("is work");
            //     })
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
