import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scouting_application/screens/homepage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        Future.delayed(
            Duration(seconds: 3),
            () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homepage())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Login"),
            automaticallyImplyLeading: false,
          ),
          body: Center(
              child: FittedBox(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.white),
                  foregroundColor:
                      MaterialStateProperty.all<Color?>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/google_logo.png", scale: 20),
                  Center(child: Text("Login With Google"))
                ],
              ),
              onPressed: () {
                googleLogin();
              },
            ),
          ))),
    );
  }

  Future<void> googleLogin() async {
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
    await FirebaseAuth.instance.signInWithCredential(googleCredential);
    // googleUserCredential.additionalUserInfo.isNewUser;
  }
}
