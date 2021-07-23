import 'package:flutter/material.dart';

class PlusMinusButton extends StatefulWidget {
  PlusMinusButton({Key? key, required this.title, required this.counter})
      : super(key: key);
  final String title;
  int counter;
  @override
  _PlusMinusButtonState createState() => _PlusMinusButtonState();
}

class _PlusMinusButtonState extends State<PlusMinusButton> {
  void _increment() {
    setState(() {
      widget.counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (widget.counter == 0) return;
      widget.counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 2.0, color: const Color(0xFFFFFFFF))),
              // color: Color.fromARGB(0, 211,211,211),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.title, style: TextStyle(fontSize: 20.0)),
                    Text('${widget.counter}', style: TextStyle(fontSize: 38)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //  mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // VerticalDivider(color: Colors.white),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: IconButton(
                                onPressed: _decrement,
                                splashRadius: 20,
                                //iconSize: 16.0,
                                icon: Icon(
                                  Icons.remove,
                                  size: 32.0,
                                )),
                          ),
                          // VerticalDivider(color: Colors.white),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: IconButton(
                                splashRadius: 20,
                                onPressed: _increment,
                                iconSize: 16.0,
                                icon: Icon(Icons.add, size: 32.0)),
                          ),
                        ]),
                  ])),
        ],
      ),
    );
  }
}
