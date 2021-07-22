import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  int test = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PlusMinusButton(title: "lior", counter: test),
    );
  }
}
