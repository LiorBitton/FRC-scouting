import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class DurationCollector extends EverCollector {
  Icon? icon;
  double _duration = 0;

  DurationCollector({Key? key, required dataTag, required title, this.icon})
      : super(key: key, dataTag: dataTag, title: title);
  @override
  _DurationCollectorState createState() => _DurationCollectorState();

  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  getValue() {
    return "${_duration.ceil().toString()} sec";
  }
}

class _DurationCollectorState extends State<DurationCollector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HoldDetector(
          onHold: _incrementTime,
          holdTimeout: Duration(milliseconds: 100),
          enableHapticFeedback: true,
          child: CircleAvatar(
              radius: 40,
              child: Column(
                children: [
                  FittedBox(
                    child: IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: widget.icon ?? Icon(Icons.timer)),
                  ),
                  FittedBox(
                      child: Text('${widget._duration.toStringAsFixed(1)}',
                          style: TextStyle(color: Colors.white)))
                ],
              )),
        ),
      ],
    );
  }

  void _incrementTime() {
    setState(() {
      widget._duration = (widget._duration + 0.1);
    });
  }
}
