import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/count_collector.dart';
import 'package:scouting_application/widgets/collectors/plus_minus_collector.dart';

class TeleoperatedTab extends ScoutingTab {
  TeleoperatedTab({Key? key, required collectors})
      : super(key: key, collectors: collectors);
  PlusMinusCollector upperCollector = PlusMinusCollector(
    title: "UPPER",
    dataTag: "tele_upper",
  );
  PlusMinusCollector lowerCollector = PlusMinusCollector(
    title: "LOWER",
    dataTag: "tele_lower",
  );

  CountCollector missLowerCollector =
      CountCollector(title: 'LOW MISS', dataTag: 'tele_lo_miss');
  CountCollector missUpperCollector =
      CountCollector(title: 'UPPER MISS', dataTag: 'tele_up_miss');
  @override
  _TeleoperatedTabState createState() => _TeleoperatedTabState();
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
    return Scaffold(body: Column(children: widget.getCollectors()));
  }
}
