import 'package:flutter/material.dart';
import 'package:scouting_application/screens/scouting/scouting_tab.dart';
import 'package:scouting_application/widgets/menu_text_button.dart';

class GeneralTab extends ScoutingTab {
  GeneralTab({Key? key, required this.onSubmit, required collectors})
      : super(key: key, collectors: collectors);
  final Function onSubmit;
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
      MenuTextButton(
          text: "submit",
          onPressed: () {
            widget.onSubmit(context);
          }),
      SizedBox(
        height: 20,
      )
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
