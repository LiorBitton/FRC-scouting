import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

// ignore: must_be_immutable
class CountCollector extends EverCollector {
  CountCollector({Key? key, required title, required dataTag})
      : super(key: key, dataTag: dataTag, title: title);

  @override
  _CountCollectorState createState() => _CountCollectorState();

  int _value = 0;
  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  getValue() {
    return _value;
  }
}

class _CountCollectorState extends State<CountCollector> {
  void _incrementCounter() {
    setState(() {
      ++widget._value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${widget.title}'),
        SizedBox(width: 15),
        FloatingActionButton(
            heroTag: widget.dataTag,
            child: Text('${widget._value}'),
            onPressed: _incrementCounter,
            shape: CircleBorder()),
      ],
    );
  }
}
