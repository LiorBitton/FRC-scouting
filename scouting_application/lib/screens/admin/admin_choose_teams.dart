import 'package:flutter/material.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class ChooseTeams extends StatefulWidget {
  ChooseTeams({Key? key, required this.teams, this.alreadySelected = const []})
      : super(key: key);
  final List<String> teams;
  final List<String> alreadySelected;
  @override
  State<ChooseTeams> createState() => _ChooseTeamsState();
}

class _ChooseTeamsState extends State<ChooseTeams> {
  Set<String> _selectedTeams = {};
  List<bool> _selectedTiles = [];
  List<String> _initiallySelected = [];
  @override
  void initState() {
    super.initState();
    _selectedTeams.addAll(widget.alreadySelected);
    _initiallySelected = widget.alreadySelected;
    _selectedTiles = List<bool>.filled(widget.teams.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        return false;
      }),
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, _selectedTeams.toList());
              },
              icon: Icon(Icons.save))
        ]),
        body: ListView.builder(
          itemCount: widget.teams.length,
          itemBuilder: (context, index) {
            final String teamID = widget.teams[index];
            if (_initiallySelected.contains(teamID)) {
              _selectedTiles[index] = true;
              _initiallySelected.remove(teamID);
            }
            return ListTile(
              title: Text(teamID),
              selected: _selectedTiles[index],
              selectedTileColor: CustomTheme.teamColor.withOpacity(0.2),
              onTap: () {
                if (_selectedTiles[index]) {
                  _selectedTeams.remove(teamID);
                } else {
                  _selectedTeams.add(teamID);
                }
                setState(() {
                  _selectedTiles[index] = !_selectedTiles[index];
                });
              },
            );
          },
        ),
      ),
    );
  }
}
