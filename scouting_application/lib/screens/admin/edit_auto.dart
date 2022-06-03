import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/count_collector.dart';
import 'package:scouting_application/widgets/collectors/dropdown_collector.dart';
import 'package:scouting_application/widgets/collectors/duration_collector.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/collectors/plus_minus_collector.dart';
import 'package:scouting_application/widgets/collectors/switch_collector.dart';
import 'package:scouting_application/widgets/collectors/text_collector.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class EditAutonomous extends StatefulWidget {
  EditAutonomous({Key? key}) : super(key: key);

  @override
  State<EditAutonomous> createState() => _EditAutonomousState();
}

class _EditAutonomousState extends State<EditAutonomous> {
  List<EverCollector> collectors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MenuButton(
            onPressed: () {
              _handleNewCollector();
            },
            isPrimary: false,
            icon: Icon(Icons.plus_one),
            iconSize: 30,
            extraPadding: 3,
            padding: 3,
          ),
        ),
        appBar: AppBar(
          title: Text("Design Autonomous"),
        ),
        body: ReorderableListView(
          onReorder: (oldidx, newidx) {
            setState(() {
              _swap(newidx, oldidx);
            });
          },
          buildDefaultDragHandles: true,
          children: [
            for (var item in collectors)
              ListTile(
                  leading: Icon(Icons.drag_handle_rounded),
                  title: IgnorePointer(child: item),
                  key: Key(item.getDataTag()))
          ],
        ));
  }

  void _swap(int newidx, oldidx) {
    newidx = newidx.clamp(0, collectors.length - 1);
    print(newidx);
    EverCollector temp = collectors[newidx];
    collectors[newidx] = collectors[oldidx];
    collectors[oldidx] = temp;
  }

  void _handleNewCollector() async {
    EverCollector? newWidget = (await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CollectorCreator(senderTag: "auto"))))
        as EverCollector;
    setState(() {
      collectors.add(newWidget);
    });
  }
}

class CollectorCreator extends StatefulWidget {
  CollectorCreator({Key? key, required this.senderTag}) : super(key: key);
  final String senderTag; //"auto","tele","end","playstyle"
  @override
  State<CollectorCreator> createState() => _CollectorCreatorState();
}

class _CollectorCreatorState extends State<CollectorCreator> {
  List<bool> _selected = List.generate(6, (index) => false);
  EverCollector? _selectedCollector;
  String _dataTag = "";
  String _collectorTitle = "";
  TextCollector _titleEditText =
      TextCollector(dataTag: "none", hintText: "Title");
  @override
  void initState() {
    super.initState();
    _dataTag = widget.senderTag + "_";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            _titleEditText,
            Spacer(),
            ToggleButtons(
              //duration,plusMinus,count,dropdown,switch,text
              children: [
                Icon(Icons.timelapse),
                Wrap(
                    spacing: 0,
                    direction: Axis.horizontal,
                    children: [Icon(Icons.remove), Icon(Icons.add)]),
                Icon(Icons.plus_one_rounded),
                Text("dropdown"),
                Icon(Icons.toggle_off_rounded),
                Icon(Icons.text_fields_rounded)
              ],
              isSelected: _selected,
              onPressed: (pressedIDX) {
                setState(() {
                  bool temp = _selected[pressedIDX];
                  _selected = List.generate(6, (index) => false);
                  _selected[pressedIDX] = !temp;
                  if (_selected[pressedIDX]) {
                    _collectorTitle = _titleEditText.getValue();
                    _dataTag = widget.senderTag + "_" + _collectorTitle;
                    _selectedCollector = getSelectedCollector(pressedIDX);
                  } else {
                    _selectedCollector = null;
                  }
                });
              },
            ),
            _selectedCollector ?? Container(),
            Spacer(),
            MenuButton(
              iconSize: 30,
              padding: 2,
              extraPadding: 2,
              icon: Icon(Icons.save),
              onPressed: () {
                Navigator.pop(context, _selectedCollector);
              },
              isPrimary: false,
            ),
            SizedBox(
              height: 20,
            )
          ]),
    );
  }

  EverCollector? getSelectedCollector(int idx) {
    EverCollector? selected;
    switch (idx) {
      case 0:
        selected = new DurationCollector(dataTag: _dataTag);
        break;
      case 1:
        selected =
            new PlusMinusCollector(title: _collectorTitle, dataTag: _dataTag);
        break;
      case 2:
        selected = new CountCollector(
          dataTag: _dataTag,
          title: _collectorTitle,
        );
        break;
      case 3:
        selected = new DropDownCollector(
          dataTag: _dataTag,
          options: [], //TODO add dropdown creation
          title: _collectorTitle,
        );
        break;
      case 4:
        selected = new SwitchCollector(
          dataTag: _dataTag,
          title: _collectorTitle,
        );
        break;
      case 5:
        selected = new TextCollector(
          dataTag: _dataTag,
          hintText: _collectorTitle,
        );
        break;
    }
    return selected;
  }
}
