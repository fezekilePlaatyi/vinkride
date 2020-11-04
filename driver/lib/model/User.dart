import 'dart:io';

import 'package:driver/utils/Utils.dart';

class User {
  // final

  signIn(String email, String password) async {
    try {
      await Utils.AUTH
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      String err = '';
      switch (e.code) {
        case 'user-not-found':
          err = 'This user is not on our records';
          break;
        default:
          err = 'Wrong Email/Password';
          break;
      }
      print(err);
    }
  }

  signUp(String name, String email, String password) async {
    try {
      String uid = '';
      await Utils.AUTH
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        uid = value.user.uid;
      }).catchError((err) {
        print(err);
      });

      await Utils.DRIVER_COLLECTION
          .doc(uid)
          .set({'name': name, 'email': email, 'created_at': Utils.NOW});
      /**
       * TO DO
       * SEND EMAIL VARIFICATION THEN PROCEED WITH REGISTRATION
       */
    } catch (e) {
      print(e);
    }
  }

  setContacts(String phone_number, String address) {}

  setAbout(String about, File id_copy) {}

  uploadProfilePic() {}

  loadCurrentUser() {
    return Utils.DRIVER_COLLECTION.doc(Utils.AUTH_USER.uid).snapshots();
  }

  getDriver(String id) {
    return Utils.DRIVER_COLLECTION.doc(id).snapshots();
  }

  getPassenger(String id) {
    return Utils.PASSENGER_COLLECTION.doc(id).snapshots();
  }

  signOut() async {
    try {
      await Utils.AUTH.signOut();
      //TO DO REDIRECT
    } catch (e) {
      print(e);
    }
  }
}
