import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/dropdown_collector.dart';
import 'package:scouting_application/widgets/collectors/duration_collector.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/collectors/switch_collector.dart';

class EndgameTab extends StatefulWidget implements ScoutingTab {
  EndgameTab({Key? key}) : super(key: key);
  SwitchCollector climbAttemptSwitch =
      SwitchCollector(title: "CLIMBING", dataTag: "climb_attempted");
  SwitchCollector climbedSwitch = SwitchCollector(
    title: 'climbed',
    dataTag: 'climbed',
  );
  DurationCollector climbTimeCollector = DurationCollector(
    dataTag: "climb_time",
    icon: Icon(Icons.elevator_rounded),
  );
  DropDownCollector<int> climbedToCollector =
      DropDownCollector(dataTag: "climb_to", options: [1, 2, 3, 4]);
      DropDownCollector<int> climbGoalCollector =
      DropDownCollector(dataTag: "climb_goal", options: [1, 2, 3, 4]);
  @override
  _EndgameTabState createState() => _EndgameTabState();

  @override
  List<EverCollector> getCollectors() {
    return [climbedSwitch, climbTimeCollector, climbAttemptSwitch,climbGoalCollector,climbedToCollector];
  }
}

class _EndgameTabState extends State<EndgameTab>
    with AutomaticKeepAliveClientMixin<EndgameTab> {
  @override
  bool get wantKeepAlive => true;
  bool didClimb = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        widget.climbTimeCollector,
        widget.climbAttemptSwitch,
        widget.climbGoalCollector,
        widget.climbedToCollector,
        Expanded(
          child: GridView(
            children: [
              SizedBox(height: 1, width: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.climbedSwitch,
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
