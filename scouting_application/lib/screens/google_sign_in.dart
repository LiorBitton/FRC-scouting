import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scouting_application/screens/homepage.dart';

class GoogleSignInScreen extends StatefulWidget {
  GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SignInButton(
      Buttons.Google,
      text: "Sign up with Google",
      onPressed: () {
        linkGoogleAndTwitter();
      },
    ));
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
