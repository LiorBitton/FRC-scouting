import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:scouting_application/widgets/menu_text_button.dart';

class AddTeamPhoto extends StatefulWidget {
  AddTeamPhoto({Key? key, required this.teamID}) : super(key: key);
  final String teamID;
  @override
  _AddTeamPhotoState createState() => _AddTeamPhotoState();
}

class _AddTeamPhotoState extends State<AddTeamPhoto> {
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  bool imageUploaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Team ${widget.teamID} - add a photo')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageUploaded
                ? getAfterSelectionUI()
                : Center(
                    child: MenuButton(
                      onPressed: () async {
                        await _showSelectionDialog(context);
                        if (imageFile != null)
                          setState(() {
                            imageUploaded = true;
                          });
                      },
                      icon: Icon(Icons.add_a_photo_rounded),
                      isPrimary: true,
                    ),
                  ),
          ],
        ));
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8)),
                Divider(),
                Padding(padding: EdgeInsets.all(8)),
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

  Column getAfterSelectionUI() {
    if (imageFile == null) {
      return Column();
    }
    File file = File(imageFile!.path);
    return Column(children: [
      Image.file(file),
      SizedBox(height: 15),
      MenuTextButton(
          onPressed: () {
            Database.instance.uploadImage(imageFile, widget.teamID);
            Navigator.pop(context);
          },
          text: "submit")
    ]);
  }

  Future _openGallery(BuildContext context) async {
    imageFile = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    imageFile = await _picker.pickImage(source: ImageSource.camera);
    Navigator.pop(context);
  }
}
