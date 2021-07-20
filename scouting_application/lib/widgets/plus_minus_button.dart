import 'package:flutter/material.dart';

class PlusMinusButton extends StatefulWidget {
  PlusMinusButton({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _PlusMinusButtonState createState() => _PlusMinusButtonState();
}

class _PlusMinusButtonState extends State<PlusMinusButton> {
  int _counter = 0;
  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter == 0) return;
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Text('$_counter', style: TextStyle(fontSize: 38)),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: _decrement,
                    iconSize: 16.0,
                    icon: Icon(
                      Icons.remove,
                      size: 32.0,
                    )),
                IconButton(
                    onPressed: _increment,
                    iconSize: 16.0,
                    icon: Icon(Icons.add, size: 32.0))
              ]),
          Text(widget.title, style: TextStyle(fontSize: 28.0))
        ]));
  }
}
