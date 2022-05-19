import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scouting_application/screens/homepage.dart';

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
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              QrImage(
                data: data,
                version: QrVersions.auto,
                size: size,
              ),
              IconButton(
                icon: Icon(Icons.check_circle_outline),
                onPressed: () {
                  Navigator.removeRouteBelow(context,
                      MaterialPageRoute(builder: (context) => Homepage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
