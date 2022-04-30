import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/admin_settings.dart';
import 'package:scouting_application/screens/stats/stats_lobby.dart';
import 'package:scouting_application/screens/scouting/scouting_menu.dart';
import 'package:scouting_application/screens/google_sign_in.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);
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
                    MaterialPageRoute(builder: (context) => ScoutingMenu()));
                // MaterialPageRoute(builder: (context) => ScoutLobby()));
              },
            ),
            SizedBox(height: 5, width: 5),
            MenuButton(
              title: 'analysis',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StatsLobby()));
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
      initGlobal();
    }
  }

  void initGlobal() async {
    Global.current_event = await FirebaseDatabase.instance
        .ref('settings/current_event')
        .get()
        .then((value) => value.value.toString());
  }
}
