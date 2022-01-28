import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/count_collector.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/collectors/plus_minus_collector.dart';

class TeleoperatedTab extends StatefulWidget implements ScoutingTab {
  TeleoperatedTab({Key? key}) : super(key: key);
  PlusMinusCollector upperCollector = PlusMinusCollector(
    title: "UPPER",
    dataTag: "tele_upper",
  );
  PlusMinusCollector lowerCollector = PlusMinusCollector(
    title: "LOWER",
    dataTag: "tele_lower",
  );

  CountCollector missCollector =
      CountCollector(title: 'miss', dataTag: 'tele_miss');
  @override
  _TeleoperatedTabState createState() => _TeleoperatedTabState();

  @override
  List<EverCollector> getCollectors() {
    return [lowerCollector, upperCollector, missCollector];
  }
}

class _TeleoperatedTabState extends State<TeleoperatedTab>
    with AutomaticKeepAliveClientMixin<TeleoperatedTab> {
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
              widget.lowerCollector,
              widget.upperCollector,
              SizedBox(height: 1, width: 1),
              widget.missCollector
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0),
          ),
        ),
      ],
    ));
  }
}
