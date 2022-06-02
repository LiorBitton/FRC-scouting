import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class PlusMinusCollector extends StatefulWidget implements EverCollector {
  PlusMinusCollector({Key? key, required this.title, required this.dataTag})
      : super(key: key);
  final String title;
  int _counter = 0;
  String dataTag;
  @override
  _PlusMinusCollectorState createState() => _PlusMinusCollectorState();

  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  getValue() {
    return _counter;
  }
}

class _PlusMinusCollectorState extends State<PlusMinusCollector> {
  void _increment() {
    setState(() {
      widget._counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (widget._counter == 0) return;
      widget._counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 15),
          MenuButton(
            iconSize: 30,
            padding: 1,
            extraPadding: 1,
            onPressed: _decrement,
            icon: Icon(Icons.remove),
            isPrimary: true,
          ),
          Expanded(child: Container()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${widget._counter}', style: TextStyle(fontSize: 38)),
              Text(widget.title, style: TextStyle(fontSize: 20.0)),
            ],
          ),
          Expanded(child: Container()),
          MenuButton(
            iconSize: 30,
            padding: 1,
            extraPadding: 1,
            onPressed: _increment,
            icon: Icon(Icons.add),
            isPrimary: true,
          ),
          SizedBox(width: 15)
        ]);
  }
}
