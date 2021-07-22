import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/custom_switch.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';

class ScoutTeleoperated extends StatefulWidget {
  ScoutTeleoperated({Key? key}) : super(key: key);

  @override
  _ScoutTeleoperatedState createState() => _ScoutTeleoperatedState();
}

class _ScoutTeleoperatedState extends State<ScoutTeleoperated>
    with AutomaticKeepAliveClientMixin<ScoutTeleoperated> {
  @override
  bool get wantKeepAlive => true;
  int inner_counter = 0;
  int outer_counter = 0;
  int lower_counter = 0;
  bool temp = false;
  @override
  void initState() {
    super.initState();
  }

  int test = 0;
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
                  CustomSwitch(title: 'moved', isSwitched: temp),
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
