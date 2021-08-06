import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/game_manager.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/collectors/plus_minus_collector.dart';
import '../../../widgets/collectors/switch_collector.dart';

class ScoutAutonomous extends StatefulWidget implements ScoutingTab {
  ScoutAutonomous({Key? key}) : super(key: key);

  PlusMinusCollector innerButton = PlusMinusCollector(
    title: "inner",
    dataTag: 'auto_inner',
  );
  PlusMinusCollector outerButton = PlusMinusCollector(
    title: "outer",
    dataTag: 'auto_outer',
  );
  PlusMinusCollector lowerButton = PlusMinusCollector(
    title: "lower",
    dataTag: 'auto_lower',
  );
  SwitchCollector movedSwitch = SwitchCollector(
    title: 'moved',
    dataTag: 'auto_moved',
  );
  @override
  _ScoutAutonomousState createState() => _ScoutAutonomousState();

  @override
  List<EverCollector> getCollectors() {
    return [innerButton, outerButton, lowerButton, movedSwitch];
  }
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
