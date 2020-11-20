import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './Drawer.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailId = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var userCredential;

  final _signUpForm = GlobalKey<FormState>();

  @override
  void dispose() {
    emailId.dispose();
    password.dispose();
    rePassword.dispose();
    super.dispose();
  }

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
    title: Text('COVID SYMPTOM CHECKER'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: app_bar,
      body: Container(
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
          child: Container(
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
                0.67,
            child: Column(
              children: [
                Form(
                  key: _signUpForm,
                  child: Column(
                    children: [
                      Text("SIGNUP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (MediaQuery.of(context).size.height -
                                  app_bar.preferredSize.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom) *
                                  0.075)),
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
                      TextFormField(
                        controller: rePassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            print(value);
                            return 'Please enter some text';
                          } else if (!((password.text.toString()) ==
                              (rePassword.text.toString()))) {
                            return 'Re-enter password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Re-Enter Password',
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
                    ],
                  ),
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
                            fontSize: (MediaQuery.of(context).size.height -
                                app_bar.preferredSize.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom) *
                                0.03),
                      ),
                      onPressed: () async {
                        var valid = 1;
                        if (_signUpForm.currentState.validate()) {
                          _onLoading();
                          try {
                            userCredential =
                                await auth.createUserWithEmailAndPassword(
                                    email: emailId.text.trim().toString(),
                                    password: password.text.trim().toString());
                          } on FirebaseAuthException catch (e) {
                            print("Error $e");
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
                            } else if (e.code == 'weak-password') {
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
                                              'This password provided is too weak.'),
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
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
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
                                              'Account already exists for this email.'),
                                          Text('Please create new login'),
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
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
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
                                        Text('There seems to be error'),
                                        Text('Error: $e'),
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
                          }
                          if (valid == 1) {
                            firestore
                                .collection('Covid App')
                                .doc('Users')
                                .collection('${userCredential.user.email}')
                                .doc('Profile')
                                .set({
                              'TotalRes': 0,
                              'Positive': 0,
                              'Negative': 0,
                              'Image': false
                            });
                            Navigator.pop(context);
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Successful'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Sign Up is successful'),
                                        Text(
                                            'You go and login with this credentials.'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacementNamed(
                                            context, '/Login Page');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text(
                        "BACK TO LOGIN",
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
                        Navigator.pushReplacementNamed(context, '/Login Page');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
