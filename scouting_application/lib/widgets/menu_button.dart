import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);
  final String title;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          heroTag: title,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: FittedBox(
            child: Text(
              '$title',
              style: TextStyle(fontSize: 20.0),
              maxLines: 1,
            ),
          ),
        ));
  }
}
