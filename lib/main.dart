import 'package:final_year_project_gnfs/pages/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/Dashboard.dart';
import 'pages/Splash.dart';

void main() {
  runApp((MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget home = Splash();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Firebase.initializeApp().whenComplete(() {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          print('User is not signed in');
          setState(() {
            home = Login();
          });
        } else {
          setState(() {
            home = Dashboard();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
