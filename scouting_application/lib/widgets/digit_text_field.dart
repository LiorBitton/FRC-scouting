import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DigitTextField extends StatelessWidget {
  DigitTextField(
      {Key? key,
      required this.textController,
      required this.hintText,
      this.maxLength})
      : super(key: key);
  int? maxLength;
  final String hintText;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: hintText),
      maxLength: maxLength ?? 4,
      maxLines: 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
}
