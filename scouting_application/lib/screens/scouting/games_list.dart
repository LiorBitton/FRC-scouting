import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/classes/secret_constants.dart';
import 'package:http/http.dart' as http;

class GamesList extends StatefulWidget {
  GamesList({Key? key}) : super(key: key);

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[100]!,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500]!,
                blurRadius: 10,
                offset: const Offset(4, 4),
                spreadRadius: 1)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                children: [
                  SizedBox(width: 1),
                  Text(
                    "Match #6",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 38,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  direction: Axis.vertical,
                  spacing: 20, // <-- Spacing between children
                  children: [
                    SizedBox(
                        width: 130,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text("7112",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700, fontSize: 26)),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))))),
                    SizedBox(
                        width: 130,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text("team"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))))),
                    SizedBox(
                        width: 130,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text("team"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))))),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  direction: Axis.vertical,
                  spacing: 20, // <-- Spacing between children
                  children: [
                    SizedBox(
                        width: 130,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text("team"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))))),
                    SizedBox(
                        width: 130,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text("team"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))))),
                    SizedBox(
                        width: 130,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text("team"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Future<Column> createUI() async{
    List<Container> content = [];
    List<Map<String, dynamic>> matches = await fetchMatches();
    for(Map<String, dynamic> match in matches){
      content.add(getMatchContainer(match));
    }
    return Column(children: content,);
  }

  Container getMatchContainer(Map<String, dynamic> match) {}
  ElevatedButton getTeamButton(bool isBlue, String teamID) {
    return ElevatedButton(
        onPressed: () {},
        child: Text(teamID,
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 26)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                isBlue ? Colors.blue : Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))));
  }

  Future<List<Map<String, dynamic>>> fetchMatches() async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/${Global.current_event}/matches/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
    List<Map<String, dynamic>> res = [];
    if (response.statusCode == 200) {}else{log('error downloading matches')}

    return res;
  }
}
