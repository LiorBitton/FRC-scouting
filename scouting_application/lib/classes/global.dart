//When adding variables add in initGlobal() inside main.dart

class Global {
  Global._privateConstructor();

  static Global _instance = Global._privateConstructor();

  static Global get instance => _instance;
  String currentEventKey = "";
  String currentEventName = "";
  bool allowFreeScouting = false;
  Map<String, String> relevantEvents = {};
  bool isAdmin = false;
  void setIsAdmin(bool isAdmin) {
    this.isAdmin = isAdmin;
  }

  Global._constructor(
      {required this.allowFreeScouting,
      required this.currentEventKey,
      required this.currentEventName,
      required this.relevantEvents});
  void fromJson(Map<String, dynamic> json) {
    try {
      Map<String, String> relevant = {};
      try {
        relevant = Map<String, String>.from(json["data_from_events"]);
      } catch (e) {
        print(e);
      }
      _instance = Global._constructor(
          allowFreeScouting: json["allow_free_scouting"],
          currentEventKey: json["current_event"]["key"],
          currentEventName: json["current_event"]["name"],
          relevantEvents: relevant);
    } catch (e) {
      print(e);
    }
  }
}
