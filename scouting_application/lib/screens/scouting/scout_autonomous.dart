import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';
import '../../widgets/custom_switch.dart';

class ScoutAutonomous extends StatefulWidget {
  ScoutAutonomous({Key? key}) : super(key: key);

  @override
  _ScoutAutonomousState createState() => _ScoutAutonomousState();
}

class _ScoutAutonomousState extends State<ScoutAutonomous> {
  bool _isSwitched = false;
  int inner_counter = 0;
  int outer_counter = 0;
  int lower_counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        SizedBox(
          height: 30,
        ),
        SizedBox(
          child: GridView(
            children: [
              PlusMinusButton(
                title: "inner",
                counter: inner_counter,
              ),
              PlusMinusButton(title: "outer", counter: outer_counter),
              PlusMinusButton(title: "lower", counter: lower_counter),
              CustomSwitch(title: 'moved', isSwitched: _isSwitched),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 0),
          ),
          height: 400,
          width: 300,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }
}
