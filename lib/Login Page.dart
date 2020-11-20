import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './User Credentials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Login extends StatefulWidget {
  UserCredential userCredential;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailId = TextEditingController();
  final password = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _loginForm = GlobalKey<FormState>();

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[700],
            ),
            height: 50,
            width: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(),
                  new Text(
                    "Loading",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var app_bar = AppBar(
    backgroundColor: Colors.grey[900],
    title: Text('COVID X-RAY PREDICTOR'),
  );

  @override
  void dispose() {
    emailId.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: app_bar,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[800],
          ),
          margin: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width -
                      MediaQuery.of(context).padding.left -
                      MediaQuery.of(context).padding.right) *
                  0.02,
              (MediaQuery.of(context).size.height -
                      app_bar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) *
                  0.02,
              (MediaQuery.of(context).size.width -
                      MediaQuery.of(context).padding.left -
                      MediaQuery.of(context).padding.right) *
                  0.02,
              (MediaQuery.of(context).size.height -
                      app_bar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) *
                  0.02),
          width: (MediaQuery.of(context).size.width -
                  MediaQuery.of(context).padding.left -
                  MediaQuery.of(context).padding.right) *
              0.96,
          height: (MediaQuery.of(context).size.height -
                  app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
              0.96,
          child: Center(
            child: Column(
              children: [
                Image(
                  image: AssetImage('Assets/Image/symptoms-icon.png'),
                  height: (MediaQuery.of(context).size.height -
                          app_bar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) *
                      0.3,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[500],
                  ),
                  margin: EdgeInsets.fromLTRB(
                      (MediaQuery.of(context).size.width -
                              MediaQuery.of(context).padding.left -
                              MediaQuery.of(context).padding.right) *
                          0.02,
                      (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                          0.02,
                      (MediaQuery.of(context).size.width -
                              MediaQuery.of(context).padding.left -
                              MediaQuery.of(context).padding.right) *
                          0.02,
                      (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                          0.02),
                  padding: EdgeInsets.fromLTRB(
                      (MediaQuery.of(context).size.width -
                              MediaQuery.of(context).padding.left -
                              MediaQuery.of(context).padding.right) *
                          0.02,
                      (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                          0.02,
                      (MediaQuery.of(context).size.width -
                              MediaQuery.of(context).padding.left -
                              MediaQuery.of(context).padding.right) *
                          0.02,
                      (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                          0.02),
                  width: (MediaQuery.of(context).size.width -
                          MediaQuery.of(context).padding.left -
                          MediaQuery.of(context).padding.right) *
                      0.9,
                  height: (MediaQuery.of(context).size.height -
                          app_bar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) *
                      0.60,
                  child: Form(
                    key: _loginForm,
                    child: Column(
                      children: [
                        Text(
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (MediaQuery.of(context).size.height -
                                  app_bar.preferredSize.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom) *
                                  0.075),
                        ),
                        TextFormField(
                          controller: emailId,
                          validator: (value) {
                            if (value.isEmpty) {
                              print(value);
                              return 'Please enter some text';
                            } else if (!value.contains('@')) {
                              return 'Please enter valid email id';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'E-Mail',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: (MediaQuery.of(context).size.height -
                                    app_bar.preferredSize.height -
                                    MediaQuery.of(context).padding.top -
                                    MediaQuery.of(context).padding.bottom) *
                                    0.03),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: (MediaQuery.of(context).size.height -
                                  app_bar.preferredSize.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom) *
                                  0.03),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value.isEmpty) {
                              print(value);
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: (MediaQuery.of(context).size.height -
                                    app_bar.preferredSize.height -
                                    MediaQuery.of(context).padding.top -
                                    MediaQuery.of(context).padding.bottom) *
                                    0.03),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: (MediaQuery.of(context).size.height -
                                  app_bar.preferredSize.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom) *
                                  0.03),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              child: Text(
                                "SIGN UP",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    (MediaQuery.of(context).size.height -
                                        app_bar.preferredSize.height -
                                        MediaQuery.of(context).padding.top -
                                        MediaQuery.of(context).padding.bottom) *
                                        0.03),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/Signup Page');
                              },
                            ),
                            RaisedButton(
                              child: Text(
                                "LOGIN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    (MediaQuery.of(context).size.height -
                                        app_bar.preferredSize.height -
                                        MediaQuery.of(context).padding.top -
                                        MediaQuery.of(context).padding.bottom) *
                                        0.03),
                              ),
                              onPressed: () async {
                                if (_loginForm.currentState.validate()) {
                                  _onLoading();
                                  var valid = 1;
                                  try {
                                    widget.userCredential = await FirebaseAuth
                                        .instance
                                        .signInWithEmailAndPassword(
                                            email:
                                                emailId.text.trim().toString(),
                                            password: password.text
                                                .trim()
                                                .toString());
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'invalid-email') {
                                      Navigator.pop(context);
                                      valid = 0;
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error!!'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text('Invalid E-mail.'),
                                                  Text(
                                                      'Please enter your email correctly.'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      print('Invalid Email.');
                                    } else if (e.code == 'user-not-found') {
                                      Navigator.pop(context);
                                      valid = 0;
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error!!'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      'No user found for this email.'),
                                                  Text(
                                                      'Please enter your email correctly.'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      print('No user found for that email.');
                                    } else if (e.code == 'wrong-password') {
                                      Navigator.pop(context);
                                      valid = 0;
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error!!'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      'Password is incorrect.'),
                                                  Text(
                                                      'Please type your password correctly.'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      print(
                                          'Wrong password provided for that user.');
                                    } else if (e.code == 'user-disabled') {
                                      Navigator.pop(context);
                                      valid = 0;
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error!!'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text('User-Disabled.'),
                                                  Text(
                                                      'You are blocked by the app provider. Please Contact app provider.'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      print('User-Disabled.');
                                    }
                                  }
                                  if (valid == 1) {
                                    print(widget.userCredential);
                                    credential.userCredential =
                                        widget.userCredential;
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(
                                        context, '/Home Page');
                                    print("Login");
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        RaisedButton(
                          child: Text(
                            "FORGOT PASSWORD",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: (MediaQuery.of(context).size.height -
                                    app_bar.preferredSize.height -
                                    MediaQuery.of(context).padding.top -
                                    MediaQuery.of(context).padding.bottom) *
                                    0.03),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/Forgot Pass Page');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
