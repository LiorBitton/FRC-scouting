import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scouting_application/screens/analysis_home.dart';
import 'package:scouting_application/screens/scouting/scout_home.dart';

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
                    MaterialPageRoute(builder: (context) => ScoutHome()));
              },
            ),
            MenuButton(
              title: 'analysis',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnalysisHome()));
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
