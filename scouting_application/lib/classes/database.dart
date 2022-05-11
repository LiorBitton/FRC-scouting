import 'package:firebase_database/firebase_database.dart';

class Database {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  Database._privateConstructor();

  static final Database _instance = Database._privateConstructor();

  static Database get instance => _instance;
  void setCurrentEvent({required String key, String name = "none"}) {
    if (name == "none") {
      name = key;
    }
    db.ref("settings/current_event_key").set(key);
    db.ref("settings/current_event_name").set(name);
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
    final DataSnapshot blockedTeamsData = await blockedTeamsRef.get();
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
    });
    return outStream;
  }
}
