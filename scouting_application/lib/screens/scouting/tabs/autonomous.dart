import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/count_collector.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/collectors/plus_minus_collector.dart';
import '../../../widgets/collectors/switch_collector.dart';

class ScoutAutonomous extends StatefulWidget implements ScoutingTab {
  ScoutAutonomous({Key? key}) : super(key: key);
  CountCollector missLowerCollector =
      CountCollector(title: 'LOW MISS', dataTag: 'auto_lo_miss');
  CountCollector missUpperCollector =
      CountCollector(title: 'UPPER MISS', dataTag: 'auto_up_miss');
  PlusMinusCollector upperCollector = PlusMinusCollector(
    title: "UPPER",
    dataTag: 'auto_upper',
  );
  PlusMinusCollector lowerCollector = PlusMinusCollector(
    title: "LOWER",
    dataTag: 'auto_lower',
  );
  SwitchCollector taxiSwitch = SwitchCollector(
    title: 'TAXI',
    dataTag: 'auto_taxi',
  );
  @override
  _ScoutAutonomousState createState() => _ScoutAutonomousState();

  @override
  List<EverCollector> getCollectors() {
    return [
      upperCollector,
      lowerCollector,
      taxiSwitch,
      missLowerCollector,
      missUpperCollector
    ];
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
              widget.upperCollector,
              widget.lowerCollector,
              widget.missLowerCollector,
              widget.missUpperCollector,
              SizedBox(height: 1, width: 1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.taxiSwitch,
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
