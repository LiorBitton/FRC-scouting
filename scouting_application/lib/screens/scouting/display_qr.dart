import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scouting_application/screens/homepage.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class DisplayQr extends StatelessWidget {
  const DisplayQr({Key? key, required this.data}) : super(key: key);
  final String data;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width - 50;
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Match Data QR"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              QrImage(
                data: data,
                version: QrVersions.auto,
                size: size,
              ),
              Spacer(
                flex: 3,
              ),
              MenuButton(
                extraPadding: 1,
                padding: 3,
                iconSize: 50,
                icon: Icon(Icons.check_circle_outline),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Homepage()));
                },
                isPrimary: false,
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
