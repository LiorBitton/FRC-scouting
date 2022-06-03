import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/collectors/ever_collector.dart';

class TextCollector extends EverCollector {
  TextCollector(
      {Key? key, required dataTag, required title, required this.hintText})
      : super(key: key, title: title, dataTag: dataTag);
  final String hintText;
  String value = "";
  @override
  _TextCollectorState createState() => _TextCollectorState();

  @override
  String getDataTag() {
    return dataTag;
  }

  @override
  getValue() {
    return value;
  }
}

class _TextCollectorState extends State<TextCollector> {
  TextEditingController _controller = new TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.value = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: widget.hintText),
    );
  }
}
