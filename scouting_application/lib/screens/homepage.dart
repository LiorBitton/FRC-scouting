import 'package:flutter/material.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/admin/admin_settings.dart';
import 'package:scouting_application/screens/scouting/scouting_menu.dart';
import 'package:scouting_application/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scouting_application/screens/stats/stats_lobby.dart';
import 'package:scouting_application/themes/custom_themes.dart';

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool allowedToPop = false;
  @override
  Widget build(BuildContext context) {
    onStart(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async => allowedToPop,
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
              IconButton(
                icon: Icon(Icons.person_off),
                onPressed: () {
                  _signOut(context);
                },
              ),
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
                Container(
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
                      icon: Icon(Icons.touch_app_rounded),
                      iconSize: 60,
                      color: isDarkMode
                          ? CustomTheme.darkTheme.scaffoldBackgroundColor
                          : CustomTheme.lightTheme.scaffoldBackgroundColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScoutingMenu()));
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
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
                      icon: Icon(Icons.query_stats_rounded),
                      iconSize: 60,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StatsLobby()));
                      }),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    allowedToPop = true;
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  void onStart(BuildContext context) {
    var currentUser = auth.currentUser;

    if (currentUser == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
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
    try {
      Global.instance.fromJson(await Database.instance.getSettings());
      Global.instance.setIsAdmin(await isAdmin());
    } catch (e) {
      Global.instance.allowFreeScouting = true;
      Global.instance.isAdmin = false;
      Global.instance.currentEventKey = "";
      Global.instance.currentEventName = "";
      Global.instance.relevantEvents = {};
      Global.instance.offlineEvent = true;
    }
  }
}
