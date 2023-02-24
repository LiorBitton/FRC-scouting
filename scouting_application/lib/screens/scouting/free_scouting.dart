import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/game_manager.dart';
import 'package:scouting_application/widgets/digit_text_field.dart';
import 'package:scouting_application/widgets/menu_text_button.dart';
import 'package:scouting_application/widgets/show_alert_dialog.dart';

class FreeScouting extends StatefulWidget {
  FreeScouting({Key? key}) : super(key: key);

  @override
  _FreeScoutingState createState() => _FreeScoutingState();
}

class _FreeScoutingState extends State<FreeScouting> {
  final matchNumberController = TextEditingController();
  final teamNumberController = TextEditingController();
  List<bool> isSelected = [true, false];
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
              ToggleButtons(
                children: <Widget>[
                  Text('Blue', style: TextStyle(color: Colors.blue[700])),
                  Text('Red', style: TextStyle(color: Colors.red[700])),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = !isSelected[buttonIndex];
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: isSelected,
              ),
              SizedBox(height: 15),
              MenuTextButton(
                  onPressed: () {
                    if (teamNumberController.text.length < 4 ||
                        matchNumberController.text.isEmpty) {
                      setState(() {
                        showAlertDialog(
                            context, "חסרים פרטים🥶", "תוסיפו פרטים🎩");
                      });
                      return;
                    }
                    String matchKey = "rf" + (matchNumberController.text);
                    int teamID = int.parse(teamNumberController.text);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameManager(
                                  matchKey: matchKey,
                                  teamNumber: teamID,
                                  isBlueAll: isSelected[0],
                                )));
                  },
                  text: "Start")
            ],
          ),
        ));
  }
}
