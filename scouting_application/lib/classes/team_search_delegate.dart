import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scouting_application/classes/team_data.dart';
import 'package:scouting_application/screens/stats/team_homepage.dart';

class TeamSearchDelegate extends SearchDelegate {
  Map<String, TeamData> searchTerms = {};
  TeamSearchDelegate(Map<String, TeamData> searchMap) {
    this.searchTerms = searchMap;
  }

  List<String> getQueryResult() {
    List<String> matchQuery = [];
    for (var item in searchTerms.keys) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    for (MapEntry<String, String> item
        in searchTerms.map((key, value) => MapEntry(value.name, key)).entries) {
      if (item.key.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.value);
      }
    }
    return matchQuery;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = getQueryResult();
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var teamNum = matchQuery[index];
          final teamData = searchTerms[teamNum]!;
          final teamAvatar = imageFromBase64String(teamData.avatar);
          final String teamName = teamData.getName();
          return ListTile(
            title: Text(teamNum),
            subtitle: Text(teamName),
            leading: teamAvatar ?? Icon(Icons.people),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamHomepage(
                          teamNumber: teamNum,
                          teamName: teamName,
                          teamAvatar: teamAvatar)));
            },
          );
        });
  }

  Image? imageFromBase64String(String base64String) {
    try {
      if (base64String == "none") return null;
      return Image.memory(base64Decode(base64String));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = getQueryResult();
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var teamNum = matchQuery[index];
          final teamData = searchTerms[teamNum]!;
          final teamAvatar = imageFromBase64String(teamData.avatar);
          final String teamName = teamData.getName();
          return ListTile(
            title: Text(teamNum),
            subtitle: Text(teamName),
            leading: teamAvatar ?? Icon(Icons.people),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamHomepage(
                          teamNumber: teamNum,
                          teamName: teamName,
                          teamAvatar: teamAvatar)));
            },
          );
        });
  }
}
