import 'package:flutter/cupertino.dart';

class GameData extends StatelessWidget {
  const GameData({Key? key, required this.teamID, required this.data})
      : super(key: key);
  final String teamID;
  final Map<String, dynamic> data;
  @override //todo generic display for data
  Widget build(BuildContext context) {
    return Container();
  }
}
