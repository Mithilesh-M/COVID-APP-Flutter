import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Drawer.dart';
import './main.dart';
import './User Credentials.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _image;

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

  Future<void> uploadFile() async {

    StorageReference ref =
    FirebaseStorage.instance.ref().child("Profile").child("${credential.userCredential.user.email}");
    StorageUploadTask uploadTask = ref.putFile(_image);
    await uploadTask.onComplete;
    }


  Future getImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      _onLoading();
      _image = File(pickedFile.path);
      await profile.update_image(true);
      await uploadFile();
      Navigator.pop(context);
    }
    await profile.get_info();
    setState(() {
      if (pickedFile != null) {
        print('Image selected');
      } else {
        print('No image selected.');
      }
    });
  }

  var app_bar=AppBar(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height -
                    app_bar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) *
                    0.65,
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
                width: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.left -
                    MediaQuery.of(context).padding.right) *
                    0.90,
                child: Center(
                  child: Container(
                    height: (MediaQuery.of(context).size.height -
                        app_bar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                        0.55,
                    child: Column(
                      children: [
                        Container(
                          height: (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                              0.425,
                          child: profile.Imagebool == false
                              ? Stack(
                                  children: [
                                    Center(
                                      child: Image(
                                        image: AssetImage(
                                            'Assets/Image/lung-icon.png'),
                                        height: (MediaQuery.of(context).size.height -
                                            app_bar.preferredSize.height -
                                            MediaQuery.of(context).padding.top -
                                            MediaQuery.of(context).padding.bottom)*0.6,
                                        width: (MediaQuery.of(context).size.width -
                                            MediaQuery.of(context).padding.left -
                                            MediaQuery.of(context).padding.right) *
                                            0.6,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'No Profile Picture',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context).size.height -
                                                app_bar.preferredSize.height -
                                                MediaQuery.of(context).padding.top -
                                                MediaQuery.of(context).padding.bottom) *
                                                0.03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                              : CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: profile.image,
                            radius: (MediaQuery.of(context).size.height -
                                app_bar.preferredSize.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom) *
                                0.2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              child: Text(
                                "Import Picture",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: (MediaQuery.of(context).size.height -
                                    app_bar.preferredSize.height -
                                    MediaQuery.of(context).padding.top -
                                    MediaQuery.of(context).padding.bottom) *
                                    0.0275),
                              ),
                              onPressed: () {
                                getImageGallery();
                                setState((){
                                });
                              },
                            ),
                            RaisedButton(
                              child: Text(
                                "Delete Picture",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: (MediaQuery.of(context).size.height -
                                    app_bar.preferredSize.height -
                                    MediaQuery.of(context).padding.top -
                                    MediaQuery.of(context).padding.bottom) *
                                    0.0275),
                              ),
                              onPressed: () async{
                                _onLoading();
                                await profile.update_image(false);
                                await profile.get_info();
                                Navigator.pop(context);
                                setState((){
                                  _image = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                    app_bar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) *
                    0.2,
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
                width: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.left -
                    MediaQuery.of(context).padding.right) *
                    0.90,
                child: Center(
                  child: Container(
                      child: Text(
                      "Email : ${credential.userCredential.user.email}",
                      style:
                          TextStyle(fontSize: (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                              0.035, fontWeight: FontWeight.bold),
                    ),
                      ),
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                    app_bar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) *
                    0.2,
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
                width: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.left -
                    MediaQuery.of(context).padding.right) *
                    0.90,
                child: Center(
                  child: Container(
                    child: Text(
                      "Total Results: ${profile.TotalRes}",
                      style:
                      TextStyle(fontSize: (MediaQuery.of(context).size.height -
                          app_bar.preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) *
                          0.035, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                    app_bar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) *
                    0.2,
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
                width: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.left -
                    MediaQuery.of(context).padding.right) *
                    0.90,
                child: Center(
                  child: Container(
                    child: Text(
                      "No.Of Positive Results: ${profile.Positive}",
                      style:
                          TextStyle(fontSize: (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                              0.035, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                    app_bar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) *
                    0.2,
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
                width: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.left -
                    MediaQuery.of(context).padding.right) *
                    0.90,
                child: Center(
                  child: Container(
                    child: Text(
                      "No.Of Negative Results: ${profile.Negative}",
                      style:
                          TextStyle(fontSize: (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                              0.035, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
