import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/admin_settings.dart';
import 'package:scouting_application/screens/stats/stats_lobby.dart';
import 'package:scouting_application/screens/scouting/scouting_menu.dart';
import 'package:scouting_application/screens/google_sign_in.dart';
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
            title: Row(
              children: [
                Text("EverScout"),
                Image.asset(
                  'assets/eg_logo_white.png',
                  color: Colors.white,
                  height: AppBar().preferredSize.height - 20,
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            actions: [
              FutureBuilder<bool>(
                future: isAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data as bool)
                      return IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminSettings()));
                          },
                          icon: Icon(Icons.admin_panel_settings));
                  }
                  return Text("");
                },
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.touch_app),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScoutingMenu()));
                    }),
                IconButton(
                    icon: Icon(Icons.query_stats),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StatsLobby()));
                    }),
              ],
            ),
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
      initGlobal();
    }
  }

  Future<bool> isAdmin() async {
    String? email = auth.currentUser!.email;
    if (email != null) {
      return Database.instance.isAdmin(email);
    }
    return false;
  }

  void initGlobal() async {
    List<String> event = await Database.instance.getCurrentEvent();
    Global.currentEventKey = event[0];
    Global.currentEventName = event[1];
    Global.allowFreeScouting = await Database.instance.getAllowFreeScouting();
    Global.isAdmin = await isAdmin();
  }
}
