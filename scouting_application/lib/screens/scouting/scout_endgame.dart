import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_submission.dart';
import 'package:scouting_application/widgets/custom_switch.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';

class ScoutEndgame extends StatefulWidget {
  ScoutEndgame({Key? key}) : super(key: key);

  @override
  _ScoutEndgameState createState() => _ScoutEndgameState();
}

class _ScoutEndgameState extends State<ScoutEndgame>
    with AutomaticKeepAliveClientMixin<ScoutEndgame> {
  @override
  bool get wantKeepAlive => true;
  int test = 0;
  bool didClimb = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          child: GridView(
            children: [
              SizedBox(height: 1, width: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSwitch(title: 'climbed', isSwitched: didClimb),
                ],
              ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0),
          ),
        ),
        FloatingActionButton(onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScoutSubmission()));
        })
      ],
    ));
  }
}
