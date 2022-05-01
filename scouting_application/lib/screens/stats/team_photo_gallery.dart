import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scouting_application/classes/secret_constants.dart';

class TeamPhotoGallery extends StatelessWidget {
  TeamPhotoGallery({Key? key, required this.teamNumber}) : super(key: key);
  final String teamNumber;
  late Future<List<Image>> futureImages;
  @override
  Widget build(BuildContext context) {
    futureImages = fetchTeamPhotos();
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<List<Image>>(
              future: futureImages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!,
                  );
                } else if (snapshot.hasError) {
                  print('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }),
        ],
      ),
    );
  }

  Future<List<Image>> fetchTeamPhotos() async {
    int year = new DateTime.now().year;
    var url = Uri.parse(
        'https://www.thebluealliance.com/api/v3/team/frc$teamNumber/media/$year');
    final response = await http.get(url, headers: {
      'X-TBA-Auth-Key': SecretConstants.TBA_API_KEY,
      'accept': 'application/json'
    });
    List<Image> out = [];
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);
      try {
        //Fetching team's logo
        out.add(
            imageFromBase64String(res[0]['details']['base64Image'].toString()));
      } catch (Exception) {
        debugPrint('failed to download logo');
      }

      for (var mediaItem in res.skip(1)) {
        try {
          Image temp = Image.network(mediaItem['direct_url']);
          out.add(temp);
        } catch (Exception) {
          try {
            //if the photo is the logo of the team
            (mediaItem['details']['base64Image']);
            out.add(imageFromBase64String(mediaItem['details']['base64Image']));
          } catch (Exception) {}
        }
      }
      return out;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load TBATeam');
    }
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }
}
