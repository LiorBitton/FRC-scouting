import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_application/screens/scouting/scout_game.dart';

class ScoutPregame extends StatefulWidget {
  ScoutPregame({Key? key}) : super(key: key);

  @override
  _ScoutPregameState createState() => _ScoutPregameState();
}

class _ScoutPregameState extends State<ScoutPregame> {
  final matchNumberController = TextEditingController();
  final teamNumberController = TextEditingController();
  @override
  void dispose() {
    matchNumberController.dispose();
    teamNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Game Scouting')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: teamNumberController,
               // initialValue: 'team number',
                maxLength: 4,
                maxLines: 1,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextFormField(
                  controller: matchNumberController,
                 // initialValue: 'match number',
                  maxLength: 3,
                  maxLines: 1,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.number),
              FloatingActionButton(
                  child: Text('start'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoutGame(
                                  matchNumber:
                                      int.parse(matchNumberController.text),
                                  teamNumber:
                                      int.parse(teamNumberController.text),
                                )));
                  }),
            ],
          ),
        ));
  }
}
