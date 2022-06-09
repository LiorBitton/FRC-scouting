import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/screens/admin/admin_settings.dart';
import 'package:scouting_application/screens/scouting/realtime_scouting.dart';
import 'package:scouting_application/screens/scouting/scouting_menu.dart';
import 'package:scouting_application/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scouting_application/screens/stats/stats_lobby.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool allowedToPop = false;
  late Future<bool> futureReady;
  @override
  void initState() {
    super.initState();

    futureReady = onStart(context);
  }

  @override
  Widget build(BuildContext context) {
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
            child: FutureBuilder(
                future: futureReady,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return snapshot.hasData
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MenuButton(
                              iconSize: MenuButton.MENU_SIZE,
                              isPrimary: true,
                              icon: Icon(Icons.touch_app_rounded),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Global.instance.allowFreeScouting
                                                ? ScoutingMenu()
                                                : RealtimeScouting()));
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            MenuButton(
                              iconSize: MenuButton.MENU_SIZE,
                              isPrimary: false,
                              icon: Icon(Icons.leaderboard_rounded),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StatsLobby()));
                              },
                            ),
                          ],
                        )
                      : Text("Loading...");
                }),
          )),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    allowedToPop = true;
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<bool> onStart(BuildContext context) async {
    var currentUser = auth.currentUser;

    if (currentUser == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      return initGlobal();
    }
    return false;
  }

  Future<bool> isAdmin() async {
    String? email = auth.currentUser!.email;
    if (email != null) {
      return Database.instance.isAdmin(email);
    }
    return false;
  }

  Future<bool> initGlobal() async {
    if (Global.instance.offlineEvent) return true;
    Map<String, List<dynamic>> tabs = {};
    try {
      Global.instance.fromJson(await Database.instance.getSettings());
      Global.instance.setIsAdmin(await isAdmin());
    } catch (e) {
      print(e);
      Global.instance.allowFreeScouting = true;
      Global.instance.isAdmin = false;
      Global.instance.currentEventKey = "";
      Global.instance.currentEventName = "";
      Global.instance.relevantEvents = {};
      Global.instance.offlineEvent = true;
    }
    try {
      tabs = await Database.instance.getTabLayout();
      saveTabsToLocal(tabs);
    } catch (e, stackTrace) {
      print(e);
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      try {
        tabs = await getTabsFromLocal();
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
      }
    }
    if (tabs.isNotEmpty) {
      Global.instance.autoCollectors =
          tabs["Autonomous"]!.map((e) => e.toString()).toList();
      Global.instance.teleCollectors =
          tabs["Teleop"]!.map((e) => e.toString()).toList();
      Global.instance.endCollectors =
          tabs["Endgame"]!.map((e) => e.toString()).toList();
      Global.instance.generalCollectors =
          tabs["General"]!.map((e) => e.toString()).toList();
    } else {
      SnackBar(content: Text("Could not find scouting req on device"));//TODO
    }
    return true;
  }

  void saveTabsToLocal(Map<String, List<dynamic>> tabs) async {
    final String filename = "tabs.json";
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$filename');
    if (!file.existsSync()) file.createSync(recursive: true);
    try {
      String out = jsonEncode(tabs);
      file.writeAsString(out);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, List<dynamic>>> getTabsFromLocal() async {
    final String filename = "tabs.json";
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$filename');
    if (!file.existsSync()) return {};
    try {
      Map<String, List<dynamic>> res = Map<String, List<dynamic>>.from(
          jsonDecode(await file.readAsString()) as Map<String, dynamic>);
      return res;
    } catch (e) {
      print(e);
      return {};
    }
  }
}
