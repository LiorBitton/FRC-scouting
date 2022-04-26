import 'package:flutter/material.dart';

class GamesList extends StatefulWidget {
  GamesList({Key? key}) : super(key: key);

  @override
  State<GamesList> createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.all(12),
              elevation: 1.2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                          onPressed: null,
                          child: Text("7112"),
                          backgroundColor: Colors.red),
                      FloatingActionButton(
                          onPressed: null,
                          child: Text("7112"),
                          backgroundColor: Colors.red),
                      FloatingActionButton(
                          onPressed: null,
                          child: Text("7112"),
                          backgroundColor: Colors.red),
                    ],
                  ),
                  Container(),
                  Column(
                    children: [
                      FloatingActionButton(
                          onPressed: null,
                          child: Text("7112"),
                          backgroundColor: Colors.blue),
                      FloatingActionButton(
                          onPressed: null,
                          child: Text("7112"),
                          backgroundColor: Colors.blue),
                      FloatingActionButton(
                          onPressed: null,
                          child: Text("7112"),
                          backgroundColor: Colors.blue),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
