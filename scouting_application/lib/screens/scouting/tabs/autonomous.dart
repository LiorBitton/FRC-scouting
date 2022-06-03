import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';

class ScoutAutonomous extends ScoutingTab {
  const ScoutAutonomous({Key? key, required collectors})
      : super(key: key, collectors: collectors);
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
    return Scaffold(body: Column(children: widget.getCollectors()));
  }
}
