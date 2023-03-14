import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/secret_constants.dart';

class Database {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  static const int TIMEOUT_TIME = 30;
  static final Database _instance = Database._privateConstructor();
  static Database get instance => _instance;
  Database._privateConstructor();
  //#region Settings
  ///Set current event to scout in.
  void setCurrentEvent({required String key, String name = "none"}) {
    if (name == "none") {
      name = key;
    }
    db.ref("settings/current_event/key").set(key);
    db.ref("settings/current_event/name").set(name);
    db.ref("settings/data_from_events").update({key: name});
  }

  ///Sets the passed team numbers as non - scoutable.
  void blockTeamsFromScouting(List<String> teams) async {
    DatabaseReference ref = db.ref("settings/blocked_teams");
    try {
      await ref.remove();
    } catch (e) {}
    await ref.set(teams);
  }

  ///Returns a list of teams that were marked as blocked by an admin.
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

  ///Sets whether free scouting is allowed for all users.
  void setAllowFreeScouting(bool allow) {
    db.ref('settings/allow_free_scouting').set(allow);
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
      return {};
    }
  }

  ///Sets the events from which data will be shown in stats screens.
  void selectEvents(Map<String, String> events) {
    db.ref("settings/data_from_events").set(events);
  }

  ///Sets tab layout for the specified tab name
  void setTabLayout(String tabName, List<String> tabLayout) {
    db.ref("settings/tabs/$tabName").set(tabLayout);
  }

  ///Returns the tab layout as saved in the database.
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

  ///Checks if a user is an admin, returns true/false correspondingly.
  Future<bool> isAdmin(String email) async {
    DataSnapshot val = await db
        .ref('settings/admins')
        .get()
        .timeout(Duration(seconds: TIMEOUT_TIME));
    return (val.value as List<Object?>).contains(email);
  }

  ///Adds admin by email, no checks are done on the String passed.
  void addAdmin(String email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('settings/admins');
    DataSnapshot data =
        await ref.get().timeout(Duration(seconds: TIMEOUT_TIME));
    List<dynamic> admins = (data.value as List).toList();
    admins.add(email);
    ref.set(admins).timeout(Duration(seconds: TIMEOUT_TIME));
  }

  ///Returns the settings from the database, If the settings don't exist, it creates default settings.
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

  //=============================================================================
  //#endregion
//#region Teams&Games
//=============================================================================
  ///Returns the keys of the events that exist for the specified team.
  Future<List<String>> getTeamsRecordedEventsKeys(String teamID) async {
    try {
      List<String> out = Map<String, dynamic>.from(
              (await db.ref("teams/${int.parse(teamID)}/events").get()).value
                  as Map<dynamic, dynamic>)
          .keys
          .toList();
      return out;
    } catch (e) {
      return [];
    }
  }

  ///Returns a stream of the teams that are being scouted at the moment.
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

  ///Delete game data from the database.
  void deleteGame(String teamKey, String gameKey, String eventKey) {
    db.ref("teams/$teamKey/events/$eventKey/gms/$gameKey").remove();
  }

  ///Checks if a team has games, returns true if it has and false otherwise.
  Future<bool> teamHasGames(String teamID, String eventKey) async {
    final teamGamesRef = db.ref("teams/$teamID/events/$eventKey/gms");
    bool exists = await teamGamesRef.once().then((value) {
      return value.snapshot.exists;
    });
    return exists;
  }

  ///Returns a stream of a games for a team.
  Stream<Map<String, dynamic>> getTeamGamesStream(
      String teamID, String eventKey) {
    final teamGamesRef = db.ref("teams/$teamID/events/$eventKey/gms");
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

  ///Marks team as currently scouted in the database
  ///
  ///Returns true if the team is not being scouted at the moment, and false otherwise
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

  ///Marks team as not being scouted at the moment.
  void notifyScoutingFinished(String teamID) {
    db.ref('sync/currently_scouted/$teamID').remove();
  }

  ///Uploads an image of the specified team.
  ///
  ///The image can be retrieved by using getTeamImages(String teamID)
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
      imageRef.set(
          downloadUrl.replaceAll(SecretConstants.TEAM_PHOTO_URL_PREFIX, ""));
    }
  }

  ///Returns urls for the photos of the specified team that were uploaded by users.
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
    return images.values
        .map((e) => "${SecretConstants.TEAM_PHOTO_URL_PREFIX}$e")
        .toList();
  }

  ///Uploads a game with the specified attributes.
  Future<void> uploadGame(Map<String, dynamic> gameData, String teamID,
      String eventKey, String gameID) async {
    db
        .ref("teams/$teamID/events/$eventKey/gms/$gameID")
        .set(gameData)
        .timeout(Duration(seconds: TIMEOUT_TIME));
  }

//=============================================================================
//#endregion
//#region analysis
//=============================================================================
  Future<Map<String, dynamic>> getEventConsistency(
      String teamID, String eventKey) async {
    final DataSnapshot data = await db
        .ref("teams/${int.parse(teamID)}/events/$eventKey/SD")
        .get()
        .timeout(Duration(seconds: TIMEOUT_TIME));
    if (data.exists) {
      return Map<String, dynamic>.from(data.value as Map<dynamic, dynamic>);
    } else {
      return {};
    }
  }

  ///Returns the average of each parameter collected in the game
  ///
  ///This function returns a Map<String,dynamic> in which
  ///
  ///keys - the parameter names
  ///
  ///values - the corresponding average values as Strings(#.##)
  Future<Map<String, dynamic>> getEventAvgs(
      String teamID, String eventKey) async {
    final DataSnapshot data = await db
        .ref("teams/${int.parse(teamID)}/events/$eventKey/avg")
        .get()
        .timeout(Duration(seconds: TIMEOUT_TIME));
    if (data.exists) {
      return Map<String, dynamic>.from(data.value as Map<dynamic, dynamic>);
    } else {
      return {};
    }
  }

  ///Recalculates averages and standard deviation for all of the values
  /// gathered in each game.
  ///
  /// The new values are uploaded to the database.
  Future<void> updateEventConsistency(String teamID, String eventKey) async {
    final Map<String, dynamic> games = Map<String, dynamic>.from(
        ((await db.ref("teams/${int.parse(teamID)}/events/$eventKey/gms").get())
                .value ??
            {"NULL": "NULL"}) as Map<dynamic, dynamic>);
    if (games.containsKey("NULL")) {
      return;
    }
    final int trunc = 2;
    final int gamesAmount = games.length;
    if (gamesAmount < 2) return;
    Map<String, num> avgs = _getGamesAvgs(games);
    db.ref("teams/${int.parse(teamID)}/events/$eventKey/avg").set(
        avgs.map((key, value) => MapEntry(key, value.toStringAsFixed(trunc))));

    //calculate the sum of each value minus its mean squared and store in standardDeviation Map
    //key : sum of (value - mean)^2
    Map<String, num> standardDeviation = {};
    for (final dynamic val in games.values) {
      Map<String, dynamic> game = Map<String, dynamic>.from(val);
      for (MapEntry<String, dynamic> entry in game.entries) {
        num entryVal = 0;
        if (entry.value.runtimeType == String) {
          String stringVal = (entry.value as String);
          if (stringVal.contains("sec")) {
            entryVal = double.parse(stringVal.replaceAll(" sec", ""));
          } else {
            continue;
          }
        } else if (entry.value.runtimeType == bool) {
          entryVal = entry.value ? 1 : 0;
        } else {
          entryVal = entry.value;
        }
        num value = pow(entryVal - avgs[entry.key]!, 2);
        standardDeviation[entry.key] =
            standardDeviation[entry.key] ?? 0 + value;
      }
    }
    //calculate the standard deviation for each key
    Map<String, String> out = {};
    for (MapEntry<String, num> sum in standardDeviation.entries) {
      out[sum.key] = sqrt(sum.value / gamesAmount).toStringAsFixed(trunc);
    }
    db.ref("teams/${int.parse(teamID)}/events/$eventKey/SD").set(out);
  }

  Map<String, num> _getGamesAvgs(Map<String, dynamic> games) {
    Map<String, num> sums = {};
    //Calculate the Mean of each of the values recorded for each game
    for (final dynamic val in games.values) {
      Map<String, dynamic> game = Map<String, dynamic>.from(val);
      for (MapEntry<String, dynamic> entry in game.entries) {
        num value = 0;
        if (entry.value.runtimeType == String) {
          String stringVal = (entry.value as String);
          if (stringVal.contains("sec")) {
            value = double.parse(stringVal.replaceAll(" sec", ""));
          } else {
            continue;
          }
        } else if (entry.value.runtimeType == bool) {
          value = entry.value ? 1 : 0;
        } else {
          value = entry.value;
        }
        sums[entry.key] = (sums[entry.key] ?? 0) + value;
      }
    }
    //turn sums map into averages map key:averageValue
    sums.forEach((key, value) => sums[key] = value / games.length);
    return sums;
  }

//=============================================================================
//#endregion
  //#region logging
  void log(String message) {
    TimeOfDay t = TimeOfDay.now();
    FirebaseCrashlytics.instance.log('${t.toString()} : $message');
  }

  void recordError(dynamic exception, StackTrace? stack) {
    FirebaseCrashlytics.instance.recordError(exception, stack);
  }
  //#endregion
}
