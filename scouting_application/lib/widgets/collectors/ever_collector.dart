import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class EverCollector extends Widget {
  final String dataTag = "";
  dynamic getValue() {}
  String getDataTag() {
    return dataTag;
  }
}
