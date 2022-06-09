import 'package:flutter/material.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class ChooseEvents extends StatefulWidget {
  ChooseEvents({Key? key, required this.events, required this.alreadySelected})
      : super(key: key);
  final Map<String, String> events;
  final Map<String, String> alreadySelected;
  @override
  State<ChooseEvents> createState() => _ChooseEventsState();
}

class _ChooseEventsState extends State<ChooseEvents> {
  Map<String, String> _selectedEvents = {};
  List<bool> _selectedTiles = [];
  Map<String, String> _initiallySelected = {};
  @override
  void initState() {
    super.initState();
    _selectedEvents.addAll(widget.alreadySelected);
    _initiallySelected = widget.alreadySelected;
    _selectedTiles = List<bool>.filled(widget.events.length, false);
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
                Navigator.pop(context, _selectedEvents);
              },
              icon: Icon(Icons.save))
        ]),
        body: ListView.builder(
          itemCount: widget.events.length,
          itemBuilder: (context, index) {
            final String eventKey = widget.events.keys.elementAt(index);
            if (_initiallySelected.keys.contains(eventKey)) {
              _selectedTiles[index] = true;
              _initiallySelected.remove(eventKey);
            }
            final String eventName = widget.events[eventKey].toString();
            return ListTile(
              title: Text(eventName),
              subtitle: Text(eventKey),
              selected: _selectedTiles[index],
              selectedTileColor: CustomTheme.teamColor.withOpacity(0.2),
              onTap: () {
                if (_selectedTiles[index]) {
                  _selectedEvents.remove(eventKey);
                } else {
                  _selectedEvents.putIfAbsent(eventKey, (() => eventName));
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
