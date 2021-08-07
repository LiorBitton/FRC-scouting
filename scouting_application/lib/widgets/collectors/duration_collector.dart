import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:scouting_application/themes/custom_themes.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class DurationCollector extends StatefulWidget implements EverCollector {
  Icon? icon;
  double _duration = 0;
  @override
  String dataTag;

  DurationCollector({Key? key, required this.dataTag, this.icon})
      : super(key: key);
  @override
  _DurationCollectorState createState() => _DurationCollectorState();

  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  getValue() {
    return _duration.ceil();
  }
}

class _DurationCollectorState extends State<DurationCollector> {
  @override
  Widget build(BuildContext context) {
    return HoldDetector(
      onHold: _incrementInactiveTime,
      holdTimeout: Duration(milliseconds: 100),
      enableHapticFeedback: true,
      child: CircleAvatar(
          backgroundColor: CustomTheme.darkTheme.primaryColor,
          radius: 40,
          child: Column(
            children: [
              FittedBox(
                child: IconButton(
                    onPressed: () {}, icon: widget.icon ?? Icon(Icons.timer)),
              ),
              FittedBox(child: Text('${widget._duration.toStringAsFixed(1)}'))
            ],
          )),
    );
  }

  void _incrementInactiveTime() {
    setState(() {
      widget._duration = (widget._duration + 0.1);
    });
  }
}