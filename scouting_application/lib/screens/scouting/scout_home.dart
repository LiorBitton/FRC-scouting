import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_application/screens/scouting/scout_autonomous.dart';
import 'package:scouting_application/screens/scouting/scout_manager.dart';
import 'package:scouting_application/widgets/plus_minus_button.dart';

class ScoutHome extends StatefulWidget {
  ScoutHome({Key? key}) : super(key: key);

  @override
  _ScoutHomeState createState() => _ScoutHomeState();
}

class _ScoutHomeState extends State<ScoutHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: 'team number',
                maxLength: 4,
                maxLines: 1,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextFormField(
                  initialValue: 'match number',
                  maxLength: 3,
                  maxLines: 1,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.number),
              FloatingActionButton(
                  child: Text('start'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoutManager()));
                  }),
            ],
          ),
        ));
  }
}
