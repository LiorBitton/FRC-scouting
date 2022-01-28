import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AnalysisGallery extends StatefulWidget {
  AnalysisGallery({Key? key, required this.teamID}) : super(key: key);
  final String teamID;
  @override
  _AnalysisGalleryState createState() => _AnalysisGalleryState();
}

class _AnalysisGalleryState extends State<AnalysisGallery> {
  List<String> urls = [];
  void fetchUrls() async {
    final ref = FirebaseDatabase.instance.ref();
    final imagesRef = ref.child('teams').child(widget.teamID).child('images');
    DataSnapshot data = await imagesRef.get();
      final images = Map<String, dynamic>.from(data.value as Map<dynamic,dynamic>);
      for (var key in images.keys) {
        urls.add(images[key]);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team #${widget.teamID} photos')),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getImages(),
          builder: (context, AsyncSnapshot<List<Image>> snapshot) {
            if (snapshot.hasData) {
              return Column(children: snapshot.data!);
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List<Image>> getImages() async {
    final ref = FirebaseDatabase.instance.ref();
    final imagesRef = ref.child('teams').child(widget.teamID).child('images');
    DataSnapshot data = await imagesRef.get();
      final stats = Map<String, dynamic>.from(data.value as Map<dynamic,dynamic>);
      for (var key in stats.keys) {
        urls.add(stats[key]);
      }
    List<Image> out = [];
    for (String url in urls) {
      out.add(
        Image.network(url, fit: BoxFit.fill),
      );
    }
    return out;
  }
}
