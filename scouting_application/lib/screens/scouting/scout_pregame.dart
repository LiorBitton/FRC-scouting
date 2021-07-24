import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_application/screens/scouting/scout_game.dart';
import 'package:scouting_application/widgets/menu_button.dart';

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
              MenuButton(
                  title: 'Start',
                  onPressed: () {
                    if (teamNumberController.text.length < 4) {
                      setState(() {
                        AlertDialog(title: Text('put number'));
                      });
                      return;
                    }
                    if (matchNumberController.text.isEmpty) {
                      setState(() {
                        AlertDialog(title: Text('put number'));
                      });
                      return;
                    }
                    int matchNumber = int.parse(matchNumberController.text);
                    int teamNumber = int.parse(teamNumberController.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoutGame(
                                  matchNumber: matchNumber,
                                  teamNumber: teamNumber,
                                )));
                  })
            ],
          ),
        ));
  }
}
