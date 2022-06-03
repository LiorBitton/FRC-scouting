import 'package:flutter/material.dart';
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

class _ScoutingTabState extends State<ScoutingTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
