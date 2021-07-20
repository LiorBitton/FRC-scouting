import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouting_application/screens/analysis_home.dart';
import 'package:scouting_application/screens/scout_home.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column( children: [SizedBox(height: 50,),
      Row( mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'EverScout',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        
      ]),
      SizedBox(height: 300),
      SizedBox(
          height: 50,
          width: 100,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScoutHome()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Scout',
                style: TextStyle(fontSize: 20.0),
                maxLines: 1,
              ))),
      SizedBox(
          height: 50,
          width: 100,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AnalysisHome()));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Analysis',
              style: TextStyle(fontSize: 20.0),
              maxLines: 1,
            ),
          )),Image(image: AssetImage('eg_logo_white.png'), height: 100,alignment: Alignment.bottomCenter,)
    ]));
  }
}
