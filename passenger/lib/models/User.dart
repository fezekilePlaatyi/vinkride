import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/utils/Utils.dart';

class User {
  Future<bool> signIn(String email, String password) async {
    try {
      return await Utils.AUTH
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Utils.AUTH_USER = value.user;
        return true;
      });
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
      errorFloatingFlushbar(err);
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      await Utils.AUTH
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        Utils.AUTH_USER = value.user;
        await Utils.PASSENGER_COLLECTION.doc(value.user.uid).set({
          'name': name,
          'email': email,
          'created_at': Utils.NOW,
          'is_user_approved': false,
          'registration_progress': 40
        });
        await Utils.AUTH_USER.sendEmailVerification();
      }).catchError((err) {
        errorFloatingFlushbar(err.message);
        return false;
      });
      return true;
    } catch (e) {
      errorFloatingFlushbar(e);
      return false;
    }
  }

  Future<bool> setAbout(
      String phone_number, String address, String id_copy) async {
    try {
      await Utils.PASSENGER_COLLECTION.doc(Utils.AUTH_USER.uid).update({
        'phone_number': phone_number,
        'address': address,
        'id_copy': id_copy,
        'registration_progress': 80
      }).catchError((err) {
        errorFloatingFlushbar(err.message);
        return false;
      });
      return true;
    } catch (e) {
      errorFloatingFlushbar(e);
      return false;
    }
  }

  Future<bool> uploadProfilePic(String profile_pic) async {
    try {
      await Utils.PASSENGER_COLLECTION.doc(Utils.AUTH_USER.uid).update({
        'profile_pic': profile_pic,
        'registration_progress': 100,
      });
      return true;
    } catch (e) {
      errorFloatingFlushbar(e);
      return false;
    }
  }

  loadCurrentUser() {
    return Utils.PASSENGER_COLLECTION.doc(Utils.AUTH_USER.uid).snapshots();
  }

  Future<DocumentSnapshot> getUserById(String userId, String userType) async {
    return FirebaseFirestore.instance
        .collection(userType.trim())
        .doc(userId.trim())
        .get();
  }

  Future<Map> getUserForCheck() async {
    return await Utils.PASSENGER_COLLECTION
        .doc(Utils.AUTH_USER.uid)
        .get()
        .then((value) {
      return value.exists ? value.data() : {};
    });
  }

  getDriver(String id) {
    return Utils.DRIVER_COLLECTION.doc(id).snapshots();
  }

  getPassenger(String id) {
    return Utils.PASSENGER_COLLECTION.doc(id).snapshots();
  }

  Future<DocumentSnapshot> isLoggedIn() async {
    try {
      if (Utils.AUTH.currentUser != null) {
        return Utils.PASSENGER_COLLECTION.doc(Utils.AUTH_USER.uid).get();
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      return await Utils.AUTH
          .sendPasswordResetEmail(email: email)
          .then((value) async {
        successFloatingFlushbar('Reset link is sent to your email');
        return true;
      });
    } catch (e) {
      String error = '';
      switch (e.code) {
        case "user-not-found":
          error = 'No user found for that email.';
          break;
        default:
          error = 'Something went wrong, Please try again!';
      }
      errorFloatingFlushbar(error);
      return false;
    }
  }

  signOut() async {
    try {
      await Utils.AUTH.signOut().then((value) {
        Utils.AUTH_USER = null;
        Routes.navigator.popAndPushNamed(Routes.loginPage);
      });
    } catch (e) {
      print(e);
    }
  }
}
