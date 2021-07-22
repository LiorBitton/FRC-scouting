import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';
import '../../widgets/custom_switch.dart';

class ScoutAutonomous extends StatefulWidget {
  ScoutAutonomous({Key? key}) : super(key: key);

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

  bool didMove = false;
  int inner_counter = 0;
  int outer_counter = 0;
  int lower_counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          child: GridView(
            children: [
              PlusMinusButton(
                title: "inner",
                counter: inner_counter,
              ),
              PlusMinusButton(title: "outer", counter: outer_counter),
              PlusMinusButton(title: "lower", counter: lower_counter),
              SizedBox(height: 1, width: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSwitch(title: 'moved', isSwitched: didMove),
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
