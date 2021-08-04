import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/custom_switch.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';

class ScoutTeleoperated extends StatefulWidget {
  ScoutTeleoperated({Key? key}) : super(key: key);
  PlusMinusButton lowerButton = PlusMinusButton(title: "lower");
  PlusMinusButton outerButton = PlusMinusButton(title: "outer");
  PlusMinusButton innerButton = PlusMinusButton(title: "inner");
  @override
  _ScoutTeleoperatedState createState() => _ScoutTeleoperatedState();
}

class _ScoutTeleoperatedState extends State<ScoutTeleoperated>
    with AutomaticKeepAliveClientMixin<ScoutTeleoperated> {
  @override
  bool get wantKeepAlive => true;

  
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
              widget.innerButton,
              widget.outerButton,
              widget.lowerButton,
              SizedBox(height: 1, width: 1),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0),
          ),
        ),
      ],
    ));
  }
}
