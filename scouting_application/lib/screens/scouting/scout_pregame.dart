import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_game.dart';
import 'package:scouting_application/widgets/digit_text_field.dart';
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
              DigitTextField(
                textController: teamNumberController,
                hintText: "team number",
                maxLength: 4,
              ),
              DigitTextField(
                textController: matchNumberController,
                hintText: 'match number',
                maxLength: 3,
              ),
              MenuButton(
                  title: 'Start',
                  onPressed: () {
                    if (teamNumberController.text.length < 4 ||
                        matchNumberController.text.isEmpty) {
                      setState(() {
                        showAlertDialog(context);
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

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FloatingActionButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("חסרים פרטים🥶"),
      content: Text("תוסיפו פרטים🎩"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
