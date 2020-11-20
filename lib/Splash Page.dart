import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './Login Page.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        margin: EdgeInsets.all(10),
        width: (MediaQuery.of(context).size.width -
            MediaQuery.of(context).padding.left -
            MediaQuery.of(context).padding.right),
        height: (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom),
        child: Center(
          child: SplashScreen(
            seconds: 1,
            navigateAfterSeconds: Login(),
            backgroundColor: Colors.grey[800],
            title: Text(
              'COVID X-RAY PREDICTOR',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) *
                      0.045),
            ),
            image: Image(
              image: AssetImage('Assets/Image/symptoms-icon.png'),
            ),
            loadingText: Text(
              'Loading',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) *
                      0.045),
            ),
            photoSize: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) *
                0.1,
            loaderColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
