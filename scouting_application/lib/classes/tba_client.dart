import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/secret_constants.dart';

class TBAClient {
  TBAClient._privateConstructor();
  static final TBAClient _instance = TBAClient._privateConstructor();
  static TBAClient get instance => _instance;

  Future<List<String>> fetchTeamsInEvent(String eventKey) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$eventKey/teams/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> eventTeams = jsonDecode(response.body);
      List<String> teams = [];
      for (var team in eventTeams) {
        String teamKey = team["key"];
        teamKey = teamKey.replaceFirst("frc", "");
        teams.add(teamKey);
      }
      return teams;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load teams for event $eventKey');
    }
  }

  ///Get a list of the israeli district events
  ///returns a map with the event key as the key and event's name as the value
  Future<Map<String, String>> fetchIsraelEvents() async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/district/${year}isr/events/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
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
  }

  Future<List<dynamic>> fetchMatchesByEvent(String eventKey) async {
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/event/$eventKey/matches/simple');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
    List<dynamic> res = [];
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
    } else {
      print('error downloading matches for event :$eventKey');
    }
    return res;
  }
}
