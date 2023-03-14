import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/screens/admin/collector_creator.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

    EverCollector temp = _collectors[newidx];
    _collectors[newidx] = _collectors[oldidx];
    _collectors[oldidx] = temp;
  }

  void _handleSave() {
    List<String> tabLayout = [];
    for (int i = 0; i < _collectors.length; ++i) {
      tabLayout.add(_collectors[i].toString());
    }
    Database.instance.setTabLayout(widget.tabName, tabLayout);
    Fluttertoast.showToast(
        msg: "Saved Layout",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    Database.instance.log(
        'Saved new tab layout for ${widget.tabName}| ${tabLayout.toString()}.');
  }

  void _handleNewCollector() async {
    EverCollector? newWidget = (await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CollectorCreator(
                    senderTag: widget.tabName.substring(0, 2).toLowerCase()))))
        as EverCollector?;
    if (newWidget != null)
      setState(() {
        _collectors.add(newWidget);
      });
  }
}
