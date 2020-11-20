import 'package:covid_app/History.dart';
import 'package:covid_app/Login%20Page.dart';
import 'package:covid_app/Profile.dart';
import 'package:covid_app/User%20Credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Drawer.dart';
import './main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  var _recognitions;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
        model: 'Assets/AI/model_unquant.tflite',
        labels: 'Assets/AI/labels.txt',
      );
      print(res);
    } catch (e) {
      print("Failed to load the model");
    }
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

  // run prediction using TFLite on given image
  Future predict() async {
    var recognitions = await Tflite.runModelOnImage(
      path: _image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    print("RECO: $recognitions");
    if (recognitions[0]["label"] == "0 Normal") {
      var TotalRes;
      var Negative;
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Profile')
          .get()
          .then((document) {
        TotalRes = document['TotalRes'] + 1;
        Negative = document['Negative'] + 1;
      });
      var TimeStamp = DateTime.now();
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Profile')
          .update({'TotalRes': TotalRes, 'Negative': Negative});
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Predictions')
          .collection('X-Ray')
          .doc('$TimeStamp')
          .set({
        'TimeStamp': TimeStamp,
        'Result': 'Negative',
        'Date': DateFormat('dd-MM-yyyy').format(TimeStamp).toString(),
        'Time': DateFormat('HH:mm:ss').format(TimeStamp).toString(),
        'Time Stamp Label': TimeStamp.toString(),
      });
    } else {
      var TotalRes;
      var Positive;
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Profile')
          .get()
          .then((document) {
        TotalRes = document['TotalRes'] + 1;
        Positive = document['Positive'] + 1;
      });
      var TimeStamp = DateTime.now();
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Profile')
          .update({'TotalRes': TotalRes, 'Positive': Positive});
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Predictions')
          .collection('X-Ray')
          .doc('$TimeStamp')
          .set({
        'TimeStamp': TimeStamp,
        'Result': 'Positive',
        'Date': DateFormat('dd-MM-yyyy').format(TimeStamp).toString(),
        'Time': DateFormat('HH:mm:ss').format(TimeStamp).toString(),
        'Time Stamp Label': TimeStamp.toString(),
      });
    }

    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  void initState() {
    super.initState();

    loadModel().then((val) {
      setState(() {});
    });
  }

  Future getImageCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  var app_bar = AppBar(
    backgroundColor: Colors.grey[900],
    title: Text('COVID X-RAY PREDICTOR'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: app_bar,
      drawer: drawer(),
      body: Container(
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
        child: Column(
          children: [
            Container(
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
              child: Column(
                children: [
                  Text(
                    "This Is COVID Predictin Using Artificial Intelligence",
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.height -
                            app_bar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                            0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Provide your PA(Posterior-Anterior) Lungs X-Ray",
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.height -
                            app_bar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                            0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),
                margin: EdgeInsets.all(0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width -
                                MediaQuery.of(context).padding.left -
                                MediaQuery.of(context).padding.right) *
                            0.8,
                        height: (MediaQuery.of(context).size.height -
                                app_bar.preferredSize.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom) *
                            0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[600],
                        ),
                        margin: EdgeInsets.all(0),
                        child: Center(
                          child: _image == null
                              ? Container(
                                  child: Column(children: [
                                  Image(
                                    image: AssetImage(
                                        'Assets/Image/radiology-icon.png'),
                                    height: (MediaQuery.of(context)
                                                .size
                                                .height -
                                            app_bar.preferredSize.height -
                                            MediaQuery.of(context).padding.top -
                                            MediaQuery.of(context)
                                                .padding
                                                .bottom) *
                                        0.275,
                                  ),
                                  Text(
                                    "No Image Selected",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          (MediaQuery.of(context).size.height -
                                                  app_bar.preferredSize.height -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .top -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .bottom) *
                                              0.035,
                                    ),
                                  ),
                                ]))
                              : Image.file(
                                  _image,
                            width: (MediaQuery.of(context).size.width -
                                MediaQuery.of(context).padding.left -
                                MediaQuery.of(context).padding.right) *
                                0.7,
                            height: (MediaQuery.of(context).size.height -
                                app_bar.preferredSize.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom) *
                                0.4,
                          ),
                        ),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height -
                            app_bar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                            0.08,
                        child: Center(
                          child: RaisedButton(
                            child: Text(
                              "CHOOSE IMAGE FROM GALLERY",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: (MediaQuery.of(context).size.height -
                                      app_bar.preferredSize.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom) *
                                      0.03),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              getImageGallery();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height -
                            app_bar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                            0.08,
                        child: Center(
                          child: RaisedButton(
                            child: Text(
                              "TAKE IMAGE FROM CAMERA",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: (MediaQuery.of(context).size.height -
                                      app_bar.preferredSize.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom) *
                                      0.03),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              getImageCamera();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height -
                            app_bar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                            0.08,
                        child: Center(
                          child: RaisedButton(
                            child: Text(
                              "DELETE IMAGE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: (MediaQuery.of(context).size.height -
                                      app_bar.preferredSize.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom) *
                                      0.03),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
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
              child: RaisedButton(
                child: Text(
                  "PREDICT",
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
                  if (_image == null) {
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
                                Text('No image selected,'),
                                Text(
                                    'Please select lungs X-Ray for COVID prediction.'),
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
                  if (_image != null) {
                    _onLoading();
                    await predict();
                    Navigator.pop(context);
                    showModalBottomSheet<dynamic>(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                              0.4,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            border: Border.all(
                              color: _recognitions[0]['label'] == '0 Normal'
                                  ? Colors.green
                                  : Colors.red, //
                              width: (MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).padding.left -
                                  MediaQuery.of(context).padding.right) *
                                  0.025,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _recognitions[0]['label'] == '0 Normal'
                                    ? Text(
                                        'NEGATIVE',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context).size.height -
                                                app_bar.preferredSize.height -
                                                MediaQuery.of(context).padding.top -
                                                MediaQuery.of(context).padding.bottom) *
                                                0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      )
                                    : Text(
                                        'POSITIVE',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context).size.height -
                                                app_bar.preferredSize.height -
                                                MediaQuery.of(context).padding.top -
                                                MediaQuery.of(context).padding.bottom) *
                                                0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                _recognitions[0]['label'] == '0 Normal'
                                    ? Text(
                                        'Stay healthy and stay safe.',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context).size.height -
                                                app_bar.preferredSize.height -
                                                MediaQuery.of(context).padding.top -
                                                MediaQuery.of(context).padding.bottom) *
                                                0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      )
                                    : Text(
                                        'Rush to nearest hospital.',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context).size.height -
                                                app_bar.preferredSize.height -
                                                MediaQuery.of(context).padding.top -
                                                MediaQuery.of(context).padding.bottom) *
                                                0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                RaisedButton(
                                  color: Colors.white,
                                  child: _recognitions[0]['label'] == '0 Normal'
                                      ? Text(
                                          'CLOSE',
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context).size.height -
                                                  app_bar.preferredSize.height -
                                                  MediaQuery.of(context).padding.top -
                                                  MediaQuery.of(context).padding.bottom) *
                                                  0.04,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        )
                                      : Text(
                                          'CLOSE',
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context).size.height -
                                                  app_bar.preferredSize.height -
                                                  MediaQuery.of(context).padding.top -
                                                  MediaQuery.of(context).padding.bottom) *
                                                  0.04,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
