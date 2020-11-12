import 'dart:io';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Utils {
  // -----------------------> AUTH <-----------------------
  static FirebaseFirestore DB = FirebaseFirestore.instance;
  static FirebaseAuth AUTH = FirebaseAuth.instance;
  static User AUTH_USER = FirebaseAuth.instance.currentUser;

  //---------------------> STORAGE <-----------------------
  static StorageReference ID_STORAGE =
      FirebaseStorage.instance.ref().child('ID_DOCUMENTS/${AUTH_USER.uid}');

  static StorageReference PROFILE_PIC_STORAGE =
      FirebaseStorage.instance.ref().child('PROFILE_PICTURE/${AUTH_USER.uid}');

  static StorageReference CHAT_FILES_STORAGE =
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
}
