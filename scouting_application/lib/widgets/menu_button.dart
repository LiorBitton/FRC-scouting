import 'package:flutter/material.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class MenuButton extends StatelessWidget {
  MenuButton({
    Key? key,
    required this.onPressed,
    required this.isPrimary,
    required this.icon,
    this.iconSize = 60,
    this.padding = 8,
    this.extraPadding = 8,
  }) : super(key: key);
  static final double MENU_SIZE = 60;
  final double padding;
  final double extraPadding;
  final double iconSize;
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
                  spreadRadius: extraPadding,
                  blurRadius: 0,
                )
              ]),
          padding: EdgeInsets.all(padding),
          child: Center(
            child: IconButton(
                icon: icon,
                iconSize: iconSize,
                color: isDarkMode
                    ? CustomTheme.darkTheme.scaffoldBackgroundColor
                    : CustomTheme.lightTheme.scaffoldBackgroundColor,
                onPressed: onPressed),
          ));
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
                spreadRadius: extraPadding,
                blurRadius: 0,
              )
            ]),
        padding: EdgeInsets.all(padding),
        child: IconButton(
            color: Colors.white,
            icon: icon,
            iconSize: iconSize,
            onPressed: onPressed),
      );
    }
  }
}
