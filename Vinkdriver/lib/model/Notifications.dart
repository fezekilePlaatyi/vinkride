import 'package:Vinkdriver/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Notifications {
  FirebaseFirestore firestore;
  CollectionReference feedsRef;
  CollectionReference userRef;
  CollectionReference passengerRef;
  String currentUserId;

  Notifications() {
    firestore = FirebaseFirestore.instance;
    feedsRef = FirebaseFirestore.instance.collection("vink_feeds");
    userRef = FirebaseFirestore.instance.collection(CollectionsConts.DRIVERS);
    passengerRef =
        FirebaseFirestore.instance.collection(CollectionsConts.PASSENGERS);
    currentUserId = FirebaseAuth.instance.currentUser.uid;
  }

  addNewNotification(Map notificationData, String personToNotifyUserId) {
    return userRef
        .doc(personToNotifyUserId.trim())
        .collection("notifications")
        .add(notificationData)
        .then((value) => value.id.toString())
        .catchError((e) => e.toString());
  }

  markNoficationAsSeen(String notificationId) {
    Map<String, dynamic> notifcationUpdateData = {
      'date_updated': FieldValue.serverTimestamp(),
      'is_seen': true
    };

    return userRef
        .doc(currentUserId.trim())
        .collection("notifications")
        .doc(notificationId.trim())
        .update(notifcationUpdateData);
  }

  Stream<QuerySnapshot> getNotificationsByUserId(String userId) {
    return userRef
        .doc(currentUserId.trim())
        .collection("notifications")
        .snapshots();
  }

  deleteNotification(String notificationId) {
    return userRef
        .doc(currentUserId.trim())
        .collection("notifications")
        .doc(notificationId.trim())
        .delete();
  }
}
