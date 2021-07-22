import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitch extends StatefulWidget {
  CustomSwitch({Key? key, required this.title, required this.isSwitched})
      : super(key: key);
  bool isSwitched;
  final String title;
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlutterSwitch(
          width: 100.0,
          height: 55.0,
          toggleSize: 45.0,
          value: widget.isSwitched,
          borderRadius: 30.0,
          padding: 2.0,
          toggleColor: Color.fromRGBO(225, 225, 225, 1),
          switchBorder: Border.all(
            color: Color.fromRGBO(2, 107, 206, 1),
            width: 6.0,
          ),
          toggleBorder: Border.all(
            color: Color.fromRGBO(2, 107, 206, 1),
            width: 5.0,
          ),
          activeColor: Color.fromRGBO(51, 226, 255, 1),
          inactiveColor: Colors.black38,
          onToggle: (val) {
            setState(() {
              widget.isSwitched = val;
            });
          },
        ),
        Center(child: Text('${widget.title}'))
      ],
    );
  }
}
