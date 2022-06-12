import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  Database._privateConstructor();
  static const int TIMEOUT_TIME = 5;
  static final Database _instance = Database._privateConstructor();

  static Database get instance => _instance;
  void setCurrentEvent({required String key, String name = "none"}) {
    if (name == "none") {
      name = key;
    }
    db.ref("settings/current_event/key").set(key);
    db.ref("settings/current_event/name").set(name);
    db.ref("settings/data_from_events").update({key: name});
  }

  Future<List<String>> getTeamsRecordedEventsKeys(String teamID) async {
    try {
      List<String> out = Map<String, dynamic>.from(
              (await db.ref("teams/${int.parse(teamID)}/events").get()).value
                  as Map<dynamic, dynamic>)
          .keys
          .toList();
      print(out);
      return out;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void blockTeamsFromScouting(List<String> teams) async {
    DatabaseReference ref = db.ref("settings/blocked_teams");
    try {
      await ref.remove();
    } catch (e) {}
    await ref.set(teams);
  }

  Future<List<String>> fetchBlockedTeams() async {
    final blockedTeamsRef = db.ref('settings/blocked_teams');
    blockedTeamsRef.keepSynced(true);
    final DataSnapshot blockedTeamsData =
        await blockedTeamsRef.get().timeout(Duration(seconds: TIMEOUT_TIME));
    List<String> blockedList = [];
    if (blockedTeamsData.exists) {
      final List<dynamic> tempBlockedList = blockedTeamsData.value as List;

      for (var item in tempBlockedList) {
        blockedList.add(item.toString());
      }
    }
    return blockedList;
  }

  Stream<List<String>> getScoutedTeamsStream() {
    final scoutedTeamsRef = db.ref("sync/currently_scouted");
    final scoutedTeamsStream = scoutedTeamsRef.onValue;
    final Stream<List<String>> outStream = scoutedTeamsStream.map((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> val = Map<String, dynamic>.from(
            (event.snapshot.value) as Map<dynamic, dynamic>);
        List<String> out = val.keys.toList();
        return out;
      }
      return [];
    });
    return outStream;
  }

  void setAllowFreeScouting(bool allow) {
    db.ref('settings/allow_free_scouting').set(allow);
  }

  Future<bool> isAdmin(String email) async {
    DataSnapshot val = await db
        .ref('settings/admins')
        .get()
        .timeout(Duration(seconds: TIMEOUT_TIME));
    return (val.value as List<Object?>).contains(email);
  }

  void deleteGame(String teamKey, String gameKey, String eventKey) {
    db.ref("teams/$teamKey/events/$eventKey/$gameKey").remove();
  }

  Future<bool> teamHasGames(String teamID, String eventKey) async {
    final teamGamesRef = db.ref("teams/$teamID/events/$eventKey");
    bool exists = await teamGamesRef.once().then((value) {
      return value.snapshot.exists;
    });
    return exists;
  }

  Stream<Map<String, dynamic>> getTeamGamesStream(
      String teamID, String eventKey) {
    final teamGamesRef = db.ref("teams/$teamID/events/$eventKey");
    final teamGamesStream = teamGamesRef.onValue;

    if (teamGamesRef.path.isEmpty) {
      return {} as Stream<Map<String, dynamic>>;
    }
    final Stream<Map<String, dynamic>> outStream = teamGamesStream.map((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> val = Map<String, dynamic>.from(
            (event.snapshot.value) as Map<dynamic, dynamic>);

        return val;
      }
      return {} as Map<String, dynamic>;
    });
    return outStream;
  }

  void notifyScoutingFinished(String teamID) {
    db.ref('sync/currently_scouted/$teamID').remove();
  }

  ///Get events that were selected by an admin to show data in stats screens
  ///
  ///returns a map key = eventKey;value = eventName;
  Future<Map<String, String>> getSelectedEvents() async {
    final ref = db.ref("settings/data_from_events");
    try {
      Map<String, String> events = Map<String, String>.from(
          (await ref.get()).value as Map<dynamic, dynamic>);
      return events;
    } catch (e) {
      print(e);
      return {};
    }
  }

  void selectEvents(Map<String, String> events) {
    db.ref("settings/data_from_events").set(events);
  }

  Future<bool> notifyStartScouting(String teamID) async {
    final dest = db.ref("sync/currently_scouted/$teamID");
    bool exists = await dest.once().then((DatabaseEvent snapshot) {
      return snapshot.snapshot.exists;
    }).timeout(Duration(seconds: TIMEOUT_TIME));
    if (exists) {
      return false;
    } else {
      await dest.set(teamID);
      return true;
    }
  }

  Future<Map<String, dynamic>> getSettings() async {
    final DatabaseReference ref = db.ref("settings");
    final DataSnapshot snapshot =
        await ref.get().timeout(Duration(seconds: TIMEOUT_TIME));
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    } else {
      Map<String, dynamic> defaultSettings = {
        "admins": ["liorb5000@gmail.com"],
        "allow_free_scouting": false,
        "current_event": {"key": "none", "name": "none"},
        "data_from_events": {}
      };
      ref.set(defaultSettings);
      return defaultSettings;
    }
  }

  Future uploadImage(XFile? imageFile, String teamID) async {
    if (imageFile == null) return;
    File file = File(imageFile.path);
    final ref = FirebaseStorage.instance.ref();
    final imageRef = ref.child('teams/$teamID/${file.path.split("/").last}');
    TaskSnapshot snapshot = await imageRef.putFile(file);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      final ref = FirebaseDatabase.instance.ref();
      final imageRef = ref.child('teams/${int.parse(teamID)}/images').push();
      imageRef.set(downloadUrl);
    }
  }

  Future<List<String>> getTeamImages(String teamID) async {
    DataSnapshot snapshot = await db
        .ref("teams/${int.parse(teamID)}/images")
        .get()
        .timeout(Duration(seconds: TIMEOUT_TIME));
    if (!snapshot.exists) {
      return [];
    }
    Map<String, String> images =
        Map<String, String>.from(snapshot.value as Map<dynamic, dynamic>);
    return images.values.toList();
  }

  void setTabLayout(String tabName, List<String> tabLayout) {
    db.ref("settings/tabs/$tabName").set(tabLayout);
  }

  Future<Map<String, List<dynamic>>> getTabLayout() async {
    DataSnapshot snapshot = await db
        .ref("settings/tabs")
        .get()
        .timeout(Duration(seconds: TIMEOUT_TIME));
    if (!snapshot.exists) {
      return {};
    }
    Map<String, List<dynamic>> tabs = Map<String, List<dynamic>>.from(
        snapshot.value as Map<dynamic, dynamic>);
    return tabs;
  }

  void addAdmin(String email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('settings/admins');
    DataSnapshot data =
        await ref.get().timeout(Duration(seconds: TIMEOUT_TIME));
    List<dynamic> admins = (data.value as List).toList();
    admins.add(email);
    ref.set(admins).timeout(Duration(seconds: TIMEOUT_TIME));
  }
}
