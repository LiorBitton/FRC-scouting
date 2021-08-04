import 'package:flutter/material.dart';
import 'package:scouting_application/widgets/menu_button.dart';

class ScoutSubmission extends StatefulWidget {
  ScoutSubmission({Key? key, required this.onSubmit}) : super(key: key);
  Function onSubmit;
  @override
  _ScoutSubmissionState createState() => _ScoutSubmissionState();
}

class _ScoutSubmissionState extends State<ScoutSubmission>
    with AutomaticKeepAliveClientMixin<ScoutSubmission> {
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Comment'),
        ),
        MenuButton(
            title: 'submit',
            onPressed: () {
              widget.onSubmit(context);
            })
      ],
    ));
  }
}
