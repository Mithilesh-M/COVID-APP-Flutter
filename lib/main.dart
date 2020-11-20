import 'package:covid_app/History.dart';
import 'package:covid_app/Login%20Page.dart';
import 'package:covid_app/Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/Home Page.dart';
import 'package:covid_app/Sign Up Page.dart';
import 'package:firebase_core/firebase_core.dart';
import './Forgot Password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Drawer.dart';
import './Splash Page.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CovidApp());
}


class CovidApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'COVID',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/Splash',
      routes: {
        '/Splash': (context) => Splash(),
        '/Profile': (context) => Profile(),
        '/Login Page': (context) => Login(),
        '/History': (context) => History(),
        '/Home Page': (context) => MyHomePage(),
        '/Signup Page': (context) => Signup(),
        '/Forgot Pass Page' : (context) => ForgPass(),
      },
    );
  }

  static var app_bar = AppBar(
    backgroundColor: Colors.grey[900],
    title: Text('COVID X-RAY PREDICTOR'),
  );
}
