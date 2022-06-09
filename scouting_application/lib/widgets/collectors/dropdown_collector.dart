import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

// ignore: must_be_immutable
class DropDownCollector<T> extends EverCollector {
  DropDownCollector(
      {Key? key, required dataTag, required this.options, required title})
      : super(key: key, dataTag: dataTag, title: title) {
    value = options[0];
  }
  final List<T> options;
  late T value;
  @override
  State<DropDownCollector> createState() => _DropDownCollectorState();

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.title),
        SizedBox(width: 20),
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
