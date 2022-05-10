//When adding variables add in initGlobal() inside main.dart
import 'package:scouting_application/classes/team_data.dart';

class Global {
  static String current_event = "";
  static bool allowFreeScouting = false;
  static Map<String, TeamData> teams = {};
  static bool isAdmin = false;
}
