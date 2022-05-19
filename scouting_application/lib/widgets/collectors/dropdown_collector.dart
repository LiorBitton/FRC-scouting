import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class DropDownCollector<T> extends StatefulWidget implements EverCollector {
  DropDownCollector(
      {Key? key,
      required this.dataTag,
      required this.options,
      required this.title})
      : super(key: key) {
    value = options[0];
  }
  List<T> options;
  late T value;
  String title;
  @override
  State<DropDownCollector> createState() => _DropDownCollectorState();

  @override
  String dataTag;

  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  getValue() {
    return value;
  }
}

class _DropDownCollectorState<T> extends State<DropDownCollector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        DropdownButton<T>(
            value: widget.value,
            items: getDropDownItems(),
            onChanged: (val) => {
                  setState(() => {widget.value = val!})
                }),
      ],
    );
  }

  List<DropdownMenuItem<T>> getDropDownItems() {
    List<DropdownMenuItem<T>> out = [];
    for (T option in widget.options) {
      DropdownMenuItem<T> curr =
          DropdownMenuItem(value: option, child: Text(option.toString()));
      out.add(curr);
    }
    return out;
  }
}
