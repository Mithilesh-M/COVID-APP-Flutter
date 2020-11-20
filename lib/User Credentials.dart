import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class credential {
  static UserCredential userCredential;
}

class profile {
  static var TotalRes;
  static var Negative;
  static var Positive;
  static var Imagebool;
  static var image;
  static var url;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static get_info() async {
    await firestore
        .collection('Covid App')
        .doc('Users')
        .collection('${credential.userCredential.user.email}')
        .doc('Profile')
        .get()
        .then((document) {
      TotalRes = document['TotalRes'];
      Positive = document['Positive'];
      Negative = document['Negative'];
      Imagebool = document['Image'];
    });
    if (Imagebool == true) {
      StorageReference ref = await FirebaseStorage.instance
          .ref()
          .child("Profile")
          .child("${credential.userCredential.user.email}");
      url = await ref.getDownloadURL();
      image = await NetworkImage(profile.url.toString());
      print(url);
    }
  }

  static update_image(var image) async {
    if (image != Imagebool) {
      if (image == false) {
        await FirebaseStorage.instance
            .ref()
            .child("Profile")
            .child("${credential.userCredential.user.email}")
            .delete();
      }
      image == true
          ? await firestore
              .collection('Covid App')
              .doc('Users')
              .collection('${credential.userCredential.user.email}')
              .doc('Profile')
              .update({'Image': true})
          : await firestore
              .collection('Covid App')
              .doc('Users')
              .collection('${credential.userCredential.user.email}')
              .doc('Profile')
              .update({'Image': false});
    }
  }
}

class history {
  static List predictions = [];

  static int count = 0;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static get_history() async {
    predictions.clear();
    await firestore
        .collection('Covid App')
        .doc('Users')
        .collection('${credential.userCredential.user.email}')
        .doc('Predictions')
        .collection('X-Ray')
        .get()
        .then((document) {
      count = document.docs.length;
    });

    for (int i = 0; i < count; i++) {
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Predictions')
          .collection("X-Ray")
          .orderBy("TimeStamp", descending: true)
          .get()
          .then((document) {
        print(document.docs[i].data());
        predictions.add(document.docs[i].data());
      });
    }
  }

  static delete_history(int index) async {
    var rec = predictions[index];
    if (rec['Result'] == 'Negative') {
      var TotalRes;
      var Negative;
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Profile')
          .get()
          .then((document) {
        TotalRes = document['TotalRes'] - 1;
        Negative = document['Negative'] - 1;
      });
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Profile')
          .update({'TotalRes': TotalRes, 'Negative': Negative});
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
        TotalRes = document['TotalRes'] - 1;
        Positive = document['Positive'] - 1;
      });
      await firestore
          .collection('Covid App')
          .doc('Users')
          .collection('${credential.userCredential.user.email}')
          .doc('Profile')
          .update({'TotalRes': TotalRes, 'Positive': Positive});
    }
    await firestore
        .collection('Covid App')
        .doc('Users')
        .collection('${credential.userCredential.user.email}')
        .doc('Predictions')
        .collection("X-Ray")
        .doc('${rec['Time Stamp Label']}')
        .delete();
    predictions.removeAt(index);
    count = count - 1;
  }
}
