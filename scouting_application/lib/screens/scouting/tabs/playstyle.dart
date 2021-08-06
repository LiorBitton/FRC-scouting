import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/collectors/duration_collector.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:scouting_application/widgets/collectors/text_collector.dart';

class PlaystyleTab extends StatefulWidget implements ScoutingTab {
  PlaystyleTab({Key? key, required this.onSubmit}) : super(key: key);
  final Function onSubmit;
  DurationCollector inactiveDuration = DurationCollector(
      dataTag: 'inactive_time', icon: Icon(Icons.report_problem));
  TextCollector commentCollector =
      TextCollector(dataTag: 'comment', hintText: 'comment');
  @override
  _PlaystyleTabState createState() => _PlaystyleTabState();

  @override
  List<EverCollector> getCollectors() {
    return [inactiveDuration, commentCollector];
  }
}

class _PlaystyleTabState extends State<PlaystyleTab>
    with AutomaticKeepAliveClientMixin<PlaystyleTab> {
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        widget.commentCollector,
        widget.inactiveDuration,
        Spacer(),
        MenuButton(
            title: 'submit',
            onPressed: () {
              widget.onSubmit(context);
            })
      ],
    ));
  }
}
