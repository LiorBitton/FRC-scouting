import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/dropdown_collector.dart';
import 'package:scouting_application/widgets/collectors/duration_collector.dart';

class EndgameTab extends ScoutingTab {
  EndgameTab({Key? key, required collectors})
      : super(key: key, collectors: collectors);

  DurationCollector climbTimeCollector = DurationCollector(
    title: "Climb time",
    dataTag: "climb_time",
    icon: Icon(Icons.elevator_rounded),
  );
  DropDownCollector<int> climbedToCollector = DropDownCollector(
      title: "CLIMBED TO", dataTag: "climb_to", options: [0, 1, 2, 3, 4]);
  DropDownCollector<int> climbGoalCollector = DropDownCollector(
      title: "TRYING TO REACH",
      dataTag: "climb_goal",
      options: [0, 1, 2, 3, 4]);
  @override
  _EndgameTabState createState() => _EndgameTabState();
}

class _EndgameTabState extends State<EndgameTab>
    with AutomaticKeepAliveClientMixin<EndgameTab> {
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
