import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/collectors/switch_collector.dart';

class EndgameTab extends StatefulWidget implements ScoutingTab {
  EndgameTab({Key? key}) : super(key: key);
  SwitchCollector climbedSwitch = SwitchCollector(
    title: 'climbed',
    dataTag: 'climbed',
  );
  @override
  _EndgameTabState createState() => _EndgameTabState();

  @override
  List<EverCollector> getCollectors() {
    return [climbedSwitch];
  }
}

class _EndgameTabState extends State<EndgameTab>
    with AutomaticKeepAliveClientMixin<EndgameTab> {
  @override
  bool get wantKeepAlive => true;
  int test = 0;
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
