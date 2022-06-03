import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class TextCollector extends EverCollector {
  TextCollector(
      {Key? key, required dataTag, required title, required this.hintText})
      : super(key: key, title: title, dataTag: dataTag);
  final String hintText;
  final TextEditingController controller = new TextEditingController();
  @override
  _TextCollectorState createState() => _TextCollectorState();

  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  getValue() {
    return controller.text;
  }
}

class _TextCollectorState extends State<TextCollector> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: widget.hintText),
    );
  }
}
