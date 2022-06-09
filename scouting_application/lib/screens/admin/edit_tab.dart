import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/screens/admin/collector_creator.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class EditTab extends StatefulWidget {
  EditTab({Key? key, required this.tabName}) : super(key: key);
  final String tabName;
  @override
  State<EditTab> createState() => _EditTabState();
}

class _EditTabState extends State<EditTab> {
  List<EverCollector> _collectors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: [
            MenuButton(
              onPressed: () {
                _handleNewCollector();
              },
              isPrimary: false,
              icon: const Icon(Icons.plus_one),
              iconSize: 30,
              extraPadding: 2,
              padding: 2,
            ),
            const SizedBox(height: 10),
            MenuButton(
              onPressed: () {
                _handleSave();
              },
              isPrimary: false,
              icon: const Icon(Icons.save),
              iconSize: 30,
              extraPadding: 2,
              padding: 2,
            ),
          ],
        ),
        appBar: AppBar(
          title: Text("Design ${widget.tabName}"),
        ),
        body: ReorderableListView(
          onReorder: (oldidx, newidx) {
            setState(() {
              _swap(newidx, oldidx);
            });
          },
          buildDefaultDragHandles: true,
          children: [
            for (var item in _collectors)
              ListTile(
                  title: IgnorePointer(child: item),
                  key: Key(item.getDataTag()))
          ],
        ));
  }

  void _swap(int newidx, oldidx) {
    newidx = newidx.clamp(0, _collectors.length - 1);
    print(newidx);
    EverCollector temp = _collectors[newidx];
    _collectors[newidx] = _collectors[oldidx];
    _collectors[oldidx] = temp;
  }

  void _handleSave() {
    List<String> tabLayout = [];
    print(_collectors);
    for (int i = 0; i < _collectors.length; ++i) {
      tabLayout.add(_collectors[i].toString());
    }
    print(tabLayout);
    Database.instance.setTabLayout(widget.tabName, tabLayout);
  }

  void _handleNewCollector() async {
    EverCollector? newWidget = (await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CollectorCreator(
                    senderTag: widget.tabName.substring(0, 2).toLowerCase()))))
        as EverCollector?;
    print(newWidget.toString());
    if (newWidget != null)
      setState(() {
        _collectors.add(newWidget);
        print(_collectors);
        print("added to collectors");
      });
  }
}
