import 'dart:io';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  // -----------------------> AUTH <-----------------------
  static FirebaseFirestore DB = FirebaseFirestore.instance;
  static FirebaseAuth AUTH = FirebaseAuth.instance;
  static User AUTH_USER = FirebaseAuth.instance.currentUser;

  //---------------------> STORAGE <-----------------------
  static Reference ID_STORAGE =
      FirebaseStorage.instance.ref().child('ID_DOCUMENTS/${AUTH_USER.uid}');

  static Reference PROFILE_PIC_STORAGE =
      FirebaseStorage.instance.ref().child('PROFILE_PICTURE/${AUTH_USER.uid}');

  static Reference CHAT_FILES_STORAGE =
      FirebaseStorage.instance.ref().child('CHAT_FILES/$MILLI_SECONDS');
  // ------------------> COLLECTIONS <---------------------
  static final DRIVER_COLLECTION = DB.collection('drivers');
  static final PASSENGER_COLLECTION = DB.collection('passengers');
  // ------------------> OTHER VARIABLES <-----------------
  static FieldValue NOW = FieldValue.serverTimestamp();
  static var MILLI_SECONDS = new DateTime.now().millisecond;

  // --------------------> FILE UPLOAD <---------------------
  static uploadIdCopy(File id_copy) async {
    // TO DO
  }

  static profilePicUpload(File profile_pic) async {
    // TO DO
  }

  static chatFile(File chat_file) async {
    //TO DO
  }

  // ----------------------> LOADERS <---------------------
  static splashScreen() {
    //To do
  }

  // -----------------------> ALERTS <---------------------
  static successFlushBar(BuildContext context, String message) {
    //To to
  }

  static errorFlushBar(BuildContext context, String message) {
    //To to
  }

  static _launchCaller(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static formatDateIntoDDMMYY(firebaseServerDateTime) {
    return DateFormat('dd-MM-yy').format(firebaseServerDateTime.toDate());
  }

  static getTimeFromFirebaseTimestamp(firebaseServerDateTime) {
    return DateFormat('kk:mm').format(firebaseServerDateTime.toDate());
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Note"),
          content: Text("Now we are about to do deduction on card"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {},
            )
          ],
        );
      },
    );
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static showAlert(context, title, subtitle, buttonText) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(buttonText),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
  }
}
