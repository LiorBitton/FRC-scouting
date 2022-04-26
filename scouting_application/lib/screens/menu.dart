import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scouting_application/screens/analysis_home.dart';
import 'package:scouting_application/screens/scouting/lobby.dart';
import 'package:scouting_application/screens/sign_in_google.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    onStart();
    return Scaffold(
        body: Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          height: 50,
        ),
        Center(
            child: Text(
          'EverScout',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        )),
        Expanded(
          child: Image.asset(
            'assets/eg_logo_white.png',
            height: 200,
          ),
        ),
        Expanded(
            child: Column(
          children: [
            MenuButton(
              title: 'scout',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoogleSignInScreen()));
                // MaterialPageRoute(builder: (context) => ScoutLobby()));
              },
            ),
            SizedBox(height: 5, width: 5),
            MenuButton(
              title: 'analysis',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnalysisHome()));
              },
            ),
            SizedBox(height: 5, width: 5),
            MenuButton(title: "disco", onPressed: () => {_signOut()})
          ],
        )),
        // FloatingActionButton(onPressed: () {
        //   firebase_core.Firebase.initializeApp();
        //   final fb = FirebaseDatabase.instance;
        //   final ref = fb.ref();
        //   ref.child('cool').set('gh');
        // })
      ]),
    ));
  }

  Future<void> _signOut() async {
    await auth.signOut();
  }

  void onStart() {
    var currentUser = auth.currentUser;
    print(currentUser);

    if (currentUser == null) {
      linkGoogleAndTwitter();
    }
  }

  Future<void> linkGoogleAndTwitter() async {
    // Trigger the Google Authentication flow.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request.
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential.
    final OAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Sign in to Firebase with the Google [UserCredential].
    final UserCredential googleUserCredential =
        await FirebaseAuth.instance.signInWithCredential(googleCredential);
  }
}
