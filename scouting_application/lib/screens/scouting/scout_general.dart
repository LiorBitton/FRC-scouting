import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:scouting_application/screens/menu.dart';
import 'package:scouting_application/widgets/digit_text_field.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class ScoutGeneral extends StatefulWidget {
  ScoutGeneral({Key? key}) : super(key: key);

  @override
  _ScoutGeneralState createState() => _ScoutGeneralState();
}

class _ScoutGeneralState extends State<ScoutGeneral> {
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  final teamNumberController = TextEditingController();
  final commentsController = TextEditingController();
  @override
  void dispose() {
    commentsController.dispose();
    teamNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('General Scouting')),
        body: Column(
          children: [
            DigitTextField(
              textController: teamNumberController,
              hintText: 'Team Number',
              maxLength: 4,
            ),
            TextField(
                controller: commentsController,
                decoration : InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Comments/Issues')
                
                ),
           
            IconButton(
              onPressed: () async {
                await _showSelectionDialog(context);
                debugPrint(imageFile?.path);
              },
              icon: Icon(Icons.add_a_photo_rounded),
            ),
            MenuButton(
                title: 'submit',
                onPressed: () {
                  uploadImageToFirebase(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Menu()));
                })
          ],
        ));
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    imageFile = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    imageFile = await _picker.pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();
  }

  Future uploadImageToFirebase(BuildContext context) async {
    File file = File(imageFile?.path ?? 'okay');
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('teams/${teamNumberController.text}')
        .putFile(file);
  }
}
