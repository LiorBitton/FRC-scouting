import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scout_game.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';
import '../../widgets/custom_switch.dart';


class ScoutAutonomous extends StatefulWidget {
  ScoutAutonomous({Key? key}) : super(key: key);

  PlusMinusButton innerButton = PlusMinusButton(
    title: "inner",
  );
  PlusMinusButton outerButton = PlusMinusButton(title: "outer");
  PlusMinusButton lowerButton = PlusMinusButton(title: "lower");
  CustomSwitch movedSwitch = CustomSwitch(title: 'moved');
  @override
  _ScoutAutonomousState createState() => _ScoutAutonomousState();
}

class _ScoutAutonomousState extends State<ScoutAutonomous>
    with AutomaticKeepAliveClientMixin<ScoutAutonomous> {
  @override
  bool get wantKeepAlive => true;

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
              widget.innerButton,
              widget.outerButton,
              widget.lowerButton,
              SizedBox(height: 1, width: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.movedSwitch,
                ],
              ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0),
          ),
        ),
      ],
    ));
  }
}
