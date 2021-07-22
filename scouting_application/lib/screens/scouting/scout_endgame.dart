import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PlusMinusButton(title: "another test", counter: test),
    );
  }
}
