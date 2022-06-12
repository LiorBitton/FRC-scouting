import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/secret_constants.dart';

class TBAClient {
  final _headers = {
    'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
    'accept': 'application/json'
  };
  TBAClient._privateConstructor();
  static final TBAClient _instance = TBAClient._privateConstructor();
  static TBAClient get instance => _instance;

  Future<List<String>> fetchTeamsInEvent(String eventKey) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$eventKey/teams/simple');
    try {
      final response = await http.get(url, headers: _headers);
      List<String> teams = [];
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<dynamic> eventTeams = jsonDecode(response.body);
        for (var team in eventTeams) {
          String teamKey = team["key"];
          teamKey = teamKey.replaceFirst("frc", "");
          teams.add(teamKey);
        }
      } else {
        FirebaseCrashlytics.instance
            .log("did not recieve a 200 response for teams in $eventKey");
      }
      return teams;
    } catch (e) {
      throw e;
    }
  }

  ///Get a list of the israeli district events
  ///returns a map with the event key as the key and event's name as the value
  Future<Map<String, String>> fetchEverGreensEvents() async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc7112/events/$year/simple');
    try {
      final response = await http.get(url, headers: _headers);
      Map<String, String> events = {};
      if (response.statusCode == 200) {
        List<dynamic> res = jsonDecode(response.body);
        for (var event in res) {
          String name = (event as Map<String, dynamic>)['name'];
          String key = event['key'];
          events[key] = name;
        }
      }
      return events;
    } catch (e) {
      print(e);
      FirebaseCrashlytics.instance.log("Failed to fetch Evergreens events");
      return {};
    }
  }

  Future<Map<String, String>> fetchIsraelEvents() async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/district/${year}isr/events/simple');
    try {
      final response = await http.get(url, headers: _headers);
      Map<String, String> events = {};
      if (response.statusCode == 200) {
        List<dynamic> res = jsonDecode(response.body);
        for (var event in res) {
          String name = (event as Map<String, dynamic>)['name'];
          String key = event['key'];
          events[key] = name;
        }
      }
      return events;
    } catch (e) {
      print(e);
      FirebaseCrashlytics.instance.log("Failed to fetch Evergreens events");
      return {};
    }
  }

  Future<List<dynamic>> fetchMatchesByEvent(String eventKey) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$eventKey/matches/simple');
    List<dynamic> res = [];
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        res = jsonDecode(response.body);
      }
    } catch (e) {
      FirebaseCrashlytics.instance
          .log('error downloading matches for event :$eventKey');
    }
    return res;
  }

  Future<String> fetchTeamNickname(String teamNumber) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/simple');
    try {
      final response = await http.get(url, headers: _headers);
      String nickname = "";
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        nickname = jsonDecode(response.body)["nickname"];
      }
      return nickname;
    } catch (e) {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      FirebaseCrashlytics.instance
          .log('Failed to load Team $teamNumber nickname');
      return "";
    }
  }

  Future<Map<String, List<String>>> fetchTeamPhotos(String teamID) async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamID/media/$year');
    try {
      final response = await http.get(url, headers: _headers);
      List<String> b64images = [];
      List<String> urlImages = [];
      if (response.statusCode == 200) {
        List<dynamic> res = jsonDecode(response.body);
        for (var mediaItem in res) {
          if (mediaItem["type"] == "avatar") continue;
          try {
            String temp = mediaItem['direct_url'];
            urlImages.add(temp);
          } catch (e) {
            try {
              //if the photo is the logo of the team
              b64images.add(mediaItem['details']['base64Image']);
            } catch (e) {}
          }
        }
      }
      return {"url": urlImages, "b64": b64images};
    } catch (e) {
      FirebaseCrashlytics.instance.log('Failed to load TBATeam');
      return {};
    }
  }

  //Returns a base64 String that represents the team's avatar
  Future<String> fetchTeamLogoAsString(String teamNumber) async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/media/$year');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      for (dynamic media in res) {
        try {
          if (media["type"] == "avatar") {
            String b64logo = res[0]['details']['base64Image'].toString();
            // print("saved $teamNumber photo to json");
            return b64logo;
          }
        } catch (exception) {
          print(exception);
          print('failed to download logo of $teamNumber');
          return "";
        }
      }
      return "none";
    } else {
      // If the server did not return a 200 OK response,
      throw Exception('Failed to load Team $teamNumber image');
    }
  }
}
