import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scouting_application/classes/database.dart';
import 'package:scouting_application/widgets/menu_button.dart';

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

  // commentsController.dispose();
  //  final commentsController = TextEditingController();
//  TextField(
  // controller: commentsController,
  // decoration: InputDecoration(
  //     border: OutlineInputBorder(), hintText: 'Comments/Issues')),
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
                // : getBeforeSelectionUI(context)

                : Center(
                    child: IconButton(
                      iconSize: 80,
                      onPressed: () async {
                        await _showSelectionDialog(context);
                        if (imageFile != null)
                          setState(() {
                            imageUploaded = true;
                          });
                      },
                      icon: Icon(Icons.add_a_photo_rounded),
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
                Padding(padding: EdgeInsets.all(100)),
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

  Center getBeforeSelectionUI(BuildContext context) {
    return Center(
        child: Wrap(
      direction: Axis.horizontal,
      spacing: 40,
      children: [
        IconButton(
            iconSize: 50,
            icon: Icon(Icons.add_to_photos),
            onPressed: () {
              setState(() {
                _openGallery(context);
                imageUploaded = true;
              });
            }),
        IconButton(
            iconSize: 50,
            icon: Icon(Icons.camera_enhance),
            onPressed: () {
              setState(() {
                _openCamera(context);

                imageUploaded = true;
              });
            })
      ],
    ));
  }

  Column getAfterSelectionUI() {
    if (imageFile == null) {
      return Column();
    }
    File file = File(imageFile!.path);
    return Column(children: [
      Image.file(file),
      MenuButton(
          title: 'submit',
          onPressed: () {
            Database.instance.uploadImage(imageFile, widget.teamID);
            Navigator.pop(context);
          })
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
