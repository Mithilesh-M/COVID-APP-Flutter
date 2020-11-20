import 'package:firebase_auth/firebase_auth.dart';

import './main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './History.dart';
import './Profile.dart';
import './Login Page.dart';
import './User Credentials.dart';


class drawer extends StatefulWidget {
  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {

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
              color: Colors.grey[700],),
            height: 50,
            width: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(),
                  new Text("Loading",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[900],
            ),
            child: Text(
              'MENU',
              style: TextStyle(
                color: Colors.white,
                fontSize: (MediaQuery.of(context).size.height -
                    CovidApp.app_bar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) *
                    0.045,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.075,
            ),
            title: Text(
              'Home',
              style: TextStyle(fontSize: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.04),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Home Page');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.075,
            ),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.04),
            ),
            onTap: () async{
              _onLoading();
              await profile.get_info();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/Profile');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              size: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.075,
            ),
            title: Text(
              'History',
              style: TextStyle(fontSize: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.04),
            ),
            onTap: () async{
              _onLoading();
              await history.get_history();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/History');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.075,
            ),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: (MediaQuery.of(context).size.height -
                  CovidApp.app_bar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom) *
                  0.04),
            ),
            onTap: () async{
              _onLoading();
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/Login Page');
            },
          ),
        ],
      ),
    );
  }
}
