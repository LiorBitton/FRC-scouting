import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:scouting_application/themes/custom_themes.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class SwitchCollector extends StatefulWidget implements EverCollector {
  SwitchCollector({Key? key, required this.title, required this.dataTag})
      : super(key: key);
  bool _isSwitched = false;
  final String title;
  @override
  _SwitchCollectorState createState() => _SwitchCollectorState();

  @override
  getValue() {
    return _isSwitched;
  }

  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  String dataTag;
}

class _SwitchCollectorState extends State<SwitchCollector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlutterSwitch(
          width: 100.0,
          height: 55.0,
          toggleSize: 45.0,
          value: widget._isSwitched,
          borderRadius: 30.0,
          padding: 2.0,
          toggleColor: Color.fromRGBO(107, 181, 46, 0.5),
          switchBorder: Border.all(
            color: Color.fromARGB(255, 107, 181, 46),
            width: 6.0,
          ),
          toggleBorder: Border.all(
            color: Color.fromARGB(255, 107, 181, 46),
            width: 5.0,
          ),
          activeColor: Color.fromRGBO(107, 181, 46, 0.5),
          inactiveColor: ThemeProvider().isLightMode?Colors.white: Colors.black,
           //Colors.white,
          onToggle: (val) {
            setState(() {
              widget._isSwitched = val;
            });
          },
        ),
        Center(
            child: Text('${widget.title}',
                style: CustomTheme.darkTheme.textTheme.bodyText1))
      ],
    );
  }
}
