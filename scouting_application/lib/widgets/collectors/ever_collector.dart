import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class EverCollector extends StatefulWidget {
  const EverCollector({Key? key, required this.dataTag, required this.title})
      : super(key: key);
  final String dataTag;
  final String title;
  String getDataTag() {
    return dataTag;
  }

  getValue() {
    return "Error - EverCollector getValue() was called";
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "$title;;$dataTag;;${this.runtimeType.toString().substring(0, 3).toLowerCase()}";
  }

  @override
  State<EverCollector> createState() => _EverCollectorState();
}

class _EverCollectorState extends State<EverCollector> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
