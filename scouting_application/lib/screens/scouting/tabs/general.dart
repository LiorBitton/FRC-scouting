import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/duration_collector.dart';
import 'package:scouting_application/widgets/collectors/text_collector.dart';

class GeneralTab extends ScoutingTab {
  GeneralTab({Key? key, required this.onSubmit, required collectors})
      : super(key: key, collectors: collectors);
  final Function onSubmit;
  DurationCollector inactiveDuration = DurationCollector(
      title: "inactive",
      dataTag: 'inactive_time',
      icon: Icon(Icons.report_problem));
  TextCollector commentCollector =
      TextCollector(title: "comment", dataTag: 'comment', hintText: 'comment');
  @override
  _PlaystyleTabState createState() => _PlaystyleTabState();
}

class _PlaystyleTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin<GeneralTab> {
  bool get wantKeepAlive => true;
  List<Widget> _layout = [];
  @override
  void initState() {
    super.initState();
    _layout = [];
    _layout.addAll(widget.getCollectors());
    _layout.addAll([
      Spacer(),
      FloatingActionButton(
          child: Text("submit"),
          onPressed: () {
            widget.onSubmit(context);
          })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: _layout,
    ));
  }
}
