import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/classes/secret_constants.dart';

class TBAClient {
  final int year;
  final String TEAM_NUMBER = "7112";
  TBAClient._privateConstructor(this.year);
  static final TBAClient _instance =
      TBAClient._privateConstructor(new DateTime.now().year);
  static TBAClient get instance => _instance;
  final _headers = {
    'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
    'accept': 'application/json'
  };
  Future<List<String>> fetchTeamsInEvent(String eventKey) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$eventKey/teams/simple');
    try {
      final response = await http.get(url, headers: _headers);
      List<String> teams = [];
      if (response.statusCode == 200) {
        List<dynamic> eventTeams = jsonDecode(response.body);
        for (var team in eventTeams) {
          String teamKey = team["key"];
          teamKey = teamKey.replaceFirst("frc", "");
          teams.add(teamKey);
        }
      } else {
        Database.instance
            .log("did not recieve a 200 response for teams in $eventKey");
      }
      return teams;
    } catch (exception, stack) {
      Database.instance.log('unknown error in fetchTeamsInEvent($eventKey).');
      Database.instance.recordError(exception, stack);
      return [];
    }
  }

  ///Get a list of the events that EverGreen is enrolled in
  ///returns a map with the event key as the key and event's name as the value
  Future<Map<String, String>> fetchEverGreensEvents() async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$TEAM_NUMBER/events/$year/simple');
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
    } catch (exception, stack) {
      Database.instance.log('Failed to fetch Evergreens events.');
      Database.instance.recordError(exception, stack);
      return {};
    }
  }

  Future<Map<String, String>> fetchIsraelEvents() async {
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
    } catch (exception, stack) {
      Database.instance.log("Failed to fetch Israel events");
      Database.instance.recordError(exception, stack);
      return {};
    }
  }

  ///
  ///Error codes:
  ///
  ///[0] - no matches are posted yet
  ///
  ///[1] - connection problem
  Future<List<dynamic>> fetchMatchesByEvent(String eventKey) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$eventKey/matches/simple');
    List<dynamic> res = [];
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        res = jsonDecode(response.body);
        if (res.isEmpty) {
          //No matches are posted for the selected event;
          Database.instance.log("No matches were posted for event $eventKey.");
          return [0];
        }
      }
    } catch (e, s) {
      Database.instance.log('Error downloading matches for event :$eventKey.');
      Database.instance.recordError(e, s);
      return [1];
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
        nickname = jsonDecode(response.body)["nickname"];
      }
      return nickname;
    } catch (exception, stack) {
      Database.instance.log('Failed to load Team $teamNumber nickname');
      Database.instance.recordError(exception, stack);
      return "";
    }
  }

  Future<Map<String, List<String>>> fetchTeamPhotos(String teamID) async {
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
    } catch (exception, stack) {
      Database.instance.log('Failed to load TBATeam');
      Database.instance.recordError(exception, stack);
      return {};
    }
  }

  //Returns a base64 String that represents the team's avatar
  Future<String> fetchTeamLogoAsString(String teamNumber) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/media/$year');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      for (dynamic media in res) {
        try {
          if (media["type"] == "avatar") {
            String b64logo = res[0]['details']['base64Image'].toString();
            //
            return b64logo;
          }
        } catch (exception, stack) {
          Database.instance.log('failed to download logo of $teamNumber');
          Database.instance.recordError(exception, stack);
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
