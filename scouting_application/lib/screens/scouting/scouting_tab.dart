import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scouting_application/themes/custom_themes.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class ScoutingTab extends StatefulWidget {
  const ScoutingTab({
    Key? key,
    required this.collectors,
  }) : super(key: key);
  final List<EverCollector> collectors;

  List<EverCollector> getCollectors() {
    return collectors;
  }

  @override
  State<ScoutingTab> createState() => _ScoutingTabState();
}

class _ScoutingTabState extends State<ScoutingTab>
    with AutomaticKeepAliveClientMixin<ScoutingTab>, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Fluttertoast.showToast(msg: "Im paused");
    }
    // if (state == AppLifecycleState.inactive) {
    //   print("\n\n\nim inactive yall\n\n\n");}
    else if (state == AppLifecycleState.detached) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      for (EverCollector item in widget.getCollectors())
        Wrap(children: [
          item,
          const Divider(
            color: CustomTheme.teamColor, // Colors.black,
            thickness: 3,
          )
        ])
    ]));
  }
}
