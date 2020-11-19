import 'package:Vinkdriver/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feeds {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final feedsRef = FirebaseFirestore.instance.collection("vink_feeds");
  final userRef = FirebaseFirestore.instance.collection("users");
  final currentUserId = FirebaseAuth.instance.currentUser.uid;

  addFeed(Map<String, dynamic> feedData) {
    return feedsRef
        .add(feedData)
        .then((value) => value.id.toString())
        .catchError((e) => e.toString());
  }

  addPassengerToFeedTrip(String feedId, String passengerId,
      Map<String, dynamic> newPassangerData) async {
    DocumentReference documentReference = feedsRef.doc(feedId.trim());

    DocumentReference userOnTripDocumentReference = feedsRef
        .doc(feedId.trim())
        .collection('users_joined_trip')
        .doc(passengerId.trim());

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot txSnapshot = await transaction.get(documentReference);
      DocumentSnapshot userOnTripSnapshot =
          await transaction.get(userOnTripDocumentReference);

      if (!txSnapshot.exists) {
        throw Exception("Document does not exist!");
      }

      int updatedVehicleSeatsNumber =
          int.parse(txSnapshot.data()['vehicle_seats_number']);

      if (!userOnTripSnapshot.exists) {
        print("User not existing on Users Already on trip");
        updatedVehicleSeatsNumber = updatedVehicleSeatsNumber - 1;
      }

      transaction.update(documentReference,
          {'vehicle_seats_number': updatedVehicleSeatsNumber.toString()});
    });

    return feedsRef
        .doc(feedId.trim())
        .collection('users_joined_trip')
        .doc(passengerId.trim())
        .set(newPassangerData)
        .then((value) => value);
  }

  updatePassangerPaymentStatus(
      String feedId, String passengerId, String paymentStatus) {
    Map<String, dynamic> passangerPaymentUpdateData = {
      'date_updated': FieldValue.serverTimestamp(),
      'payment_status': paymentStatus,
    };

    return feedsRef
        .doc(feedId.trim())
        .collection('users_joined_trip')
        .doc(passengerId.trim())
        .update(passangerPaymentUpdateData);
  }

  Stream<QuerySnapshot> getAllFeeds(String feedType) {
    return feedsRef
        .orderBy("date_updated", descending: true)
        .where("feed_type", isEqualTo: feedType)
        .snapshots();
  }

  Stream<QuerySnapshot> getFeedPassengersById(String feedId) {
    return feedsRef
        .doc(feedId.trim())
        .collection('users_joined_trip')
        .snapshots();
  }

  Future<DocumentSnapshot> getFeedById(String feedId) {
    return feedsRef.doc(feedId.trim()).get();
  }

  getRidesByUserId(String userId, String rideType) {
    return feedsRef
        .orderBy("date_updated", descending: true)
        .where("sender_uid", isEqualTo: userId.trim())
        .where("feed_type", isEqualTo: rideType)
        .snapshots();
  }

  getFeedsByUserId(String userId) {
    return feedsRef
        .orderBy("date_updated", descending: true)
        .where("sender_uid", isEqualTo: userId.trim())
        .snapshots();
  }

  getInterestsByUserId(String userId) {
    return feedsRef
        .orderBy("date_updated", descending: true)
        .where("sender_uid", isEqualTo: userId.trim())
        .where("feed_type", isEqualTo: 'interests')
        .snapshots();
  }

  getTripsByUserId(String userId, String status) {
    return feedsRef
        .orderBy("date_updated", descending: true)
        .where("sender_uid", isEqualTo: userId.trim())
        .where("feed_status", isEqualTo: status.trim())
        .where("feed_type", isEqualTo: TripConst.RIDE_OFFER)
        .snapshots();
  }

  getFeedsByArrayOfFeedsIds(List feedsListOfId) {
    return feedsRef.where(FieldPath.documentId, whereIn: feedsListOfId);
  }

  searchRideByDepartureAndDestination(
      String departure, String destination, String feedType) {
    return feedsRef
        .orderBy("date_updated", descending: true)
        .where("departure_point", isEqualTo: departure.trim())
        .where("destination_point", isEqualTo: destination.trim())
        .where("feed_type", isEqualTo: TripConst.RIDE_OFFER)
        .snapshots();
  }

  updateFeedStatusById(String feedId, String feedUpdateStatus) {
    print("onUpdate feed status");
    Map<String, dynamic> feedUpdateData = {
      'date_updated': FieldValue.serverTimestamp(),
      'feed_status': feedUpdateStatus,
    };

    return feedsRef.doc(feedId.trim()).update(feedUpdateData);
  }

  Future<void> updateFeedByFeedId(Map updateData, String feedId) async {
    await feedsRef.doc(feedId.trim()).update(updateData);
  }

  deletePassangerOnTrip(String feedId, String passengerId) {
    return feedsRef
        .doc(feedId.trim())
        .collection('users_joined_trip')
        .doc(passengerId.trim())
        .delete();
  }

  deleteFeedById(String feedId) {
    return feedsRef.doc(feedId.trim()).delete();
  }
}
