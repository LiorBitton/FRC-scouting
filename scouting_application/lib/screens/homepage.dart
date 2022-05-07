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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text("EverScout"),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminSettings()));
                  },
                  icon: Icon(Icons.admin_panel_settings))
            ],
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                  ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScoutingMenu()));
                          // MaterialPageRoute(builder: (context) => ScoutLobby()));
                        },
                      ),
                      SizedBox(height: 5, width: 5),
                      MenuButton(
                        title: 'analysis',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatsLobby()));
                        },
                      ),
                      SizedBox(height: 5, width: 5),
                    ],
                  )),
                ]),
          )),
    );
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
      ("user is connected");
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
