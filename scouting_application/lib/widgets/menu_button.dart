import 'package:flutter/material.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.onPressed,
    required this.isPrimary,
    required this.icon,
  }) : super(key: key);
  final bool isPrimary;
  final Widget icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (isPrimary) {
      return Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
              shadows: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 8,
                  blurRadius: 0,
                )
              ]),
          padding: EdgeInsets.all(8),
          child: IconButton(
              icon: icon,
              iconSize: 60,
              color: isDarkMode
                  ? CustomTheme.darkTheme.scaffoldBackgroundColor
                  : CustomTheme.lightTheme.scaffoldBackgroundColor,
              onPressed: onPressed));
    } else {
      return Container(
        decoration: ShapeDecoration(
            color: isDarkMode
                ? CustomTheme.darkTheme.scaffoldBackgroundColor
                : CustomTheme.lightTheme.scaffoldBackgroundColor,
            shape: CircleBorder(),
            shadows: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 8,
                blurRadius: 0,
              )
            ]),
        padding: EdgeInsets.all(8),
        child: IconButton(
            color: Colors.white,
            icon: icon,
            iconSize: 60,
            onPressed: onPressed),
      );
    }
  }
}
