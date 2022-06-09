import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class MenuTextButton extends StatelessWidget {
  const MenuTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          child: Text(text,
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 26)),
        ),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>((CustomTheme.teamColor)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ))));
  }
}
