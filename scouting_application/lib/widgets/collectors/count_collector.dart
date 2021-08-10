import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class CountCollector extends StatefulWidget implements EverCollector {
  CountCollector({Key? key, required this.title, required this.dataTag})
      : super(key: key);

  @override
  _CountCollectorState createState() => _CountCollectorState();

  @override
  String dataTag;
  String title;
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
    return Column(
      children: [
        FloatingActionButton(
            child: Text('${widget._value}'),
            onPressed: _incrementCounter,
            shape: CircleBorder()),
        Text('${widget.title}')
      ],
    );
  }
}
