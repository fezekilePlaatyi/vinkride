import 'package:cloud_firestore/cloud_firestore.dart';

class Vink {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final feedsRef = FirebaseFirestore.instance.collection("vink_details");

  Stream<QuerySnapshot> getCompanyDetails() {
    return feedsRef.snapshots();
  }
}
