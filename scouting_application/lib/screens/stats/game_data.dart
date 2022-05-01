import 'package:flutter/material.dart';

class GameData extends StatelessWidget {
  const GameData({Key? key, required this.teamID, required this.data})
      : super(key: key);
  final String teamID;
  final Map<String, dynamic> data;
  @override //todo generic display for data
  Widget build(BuildContext context) {
    List<String> dataKeys = data.keys.toList();
    return Scaffold(
        body: ListView.builder(
            itemCount: dataKeys.length,
            itemBuilder: ((context, index) {
              return ListTile(
                  title: Text(
                      '${dataKeys.elementAt(index)} : ${data[dataKeys[index]].toString()}'));
            })));
  }
}
