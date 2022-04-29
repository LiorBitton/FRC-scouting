import 'package:flutter/material.dart';
import 'package:scouting_application/screens/admin.dart';
import 'package:scouting_application/screens/analysis_home.dart';
import 'package:scouting_application/screens/scouting/lobby.dart';
import 'package:scouting_application/screens/sign_in_google.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    onStart(context);
    return Scaffold(
        body: Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          height: 50,
        ),
        Center(
            child: Text(
          'EverScout',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        )),
        Expanded(
          child: Image.asset(
            'assets/eg_logo_white.png',
            height: 200,
          ),
        ),
        Expanded(
            child: Column(
          children: [
            // IconButton(
            //     icon: Icon(Icons.touch_app),
            //     onPressed: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => ScoutLobby()));
            //     }),
            // IconButton(
            //     icon: Icon(Icons.query_stats),
            //     onPressed: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => AnalysisHome()));
            //     }),
            MenuButton(
              title: 'scout',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScoutLobby()));
                // MaterialPageRoute(builder: (context) => ScoutLobby()));
              },
            ),
            SizedBox(height: 5, width: 5),
            MenuButton(
              title: 'analysis',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnalysisHome()));
              },
            ),
            SizedBox(height: 5, width: 5),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminSettings()));
                },
                icon: Icon(Icons.admin_panel_settings))
          ],
        )),
      ]),
    ));
  }

  Future<void> _signOut() async {
    await auth.signOut();
  }

  void onStart(BuildContext context) {
    var currentUser = auth.currentUser;

    if (currentUser == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GoogleSignInScreen()));
    } else {
      print("user is connected");
    }
  }
}
