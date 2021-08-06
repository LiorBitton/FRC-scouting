import 'package:flutter/cupertino.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

abstract class ScoutingTab extends Widget {
  List<EverCollector> getCollectors() {
    return [];
  }
}
