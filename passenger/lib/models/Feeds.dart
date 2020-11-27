import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/routes/routes.gr.dart';

class Feeds {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final feedsRef = FirebaseFirestore.instance.collection("vink_feeds");
  final userRef = FirebaseFirestore.instance.collection("users");
  final currentUserId = "FirebaseAuth.instance.currentUser.uid";

  addFeed(Map<String, dynamic> feedData) {
    return feedsRef
        .add(feedData)
        .then((value) => value.id.toString())
        .catchError((e) => e.toString());
  }

  addPassengerToFeedTrip(String feedId, String passengerId,
      Map<String, dynamic> newPassangerData) async {
    /*
      TO: Do - This function needs to be break down into pieces
      it does a couple of things and which include checking if 
      trip is not full updating number of remaining seats,
      and finaly adds user to trip.
    */
    DocumentReference tripDocumentRef = feedsRef.doc(feedId.trim());

    DocumentReference userOnTripDocRef = feedsRef
        .doc(feedId.trim())
        .collection('users_joined_trip')
        .doc(passengerId.trim());

    DocumentSnapshot tripSnapshot = await tripDocumentRef.get();

    if (!tripSnapshot.exists) {
      return TripConst.TRIP_NOT_EXISTING_CODE;
    } else {
      var userOnTripResults = userOnTripDocRef.get();

      userOnTripResults.then((userOnTripSnapshot) {
        if (!userOnTripSnapshot.exists) {
          int updatedVehicleSeatsNumber =
              tripSnapshot.data()['vehicle_seats_number'];
          print("About to be added");
          if (updatedVehicleSeatsNumber >= 1) {
            updatedVehicleSeatsNumber = updatedVehicleSeatsNumber - 1;

            tripDocumentRef.update({
              'vehicle_seats_number': updatedVehicleSeatsNumber
            }).then((value) {
              print("updated number of seats");
              return feedsRef
                  .doc(feedId.trim())
                  .collection('users_joined_trip')
                  .doc(passengerId.trim())
                  .set(newPassangerData)
                  .then((value) => value)
                  .catchError((err) => err);
            });
          } else {
            print("Trip is full");
            return TripConst.TRIP_IS_FULL_CODE;
          }
        } else {
          print("User existing");
          return TripConst.USER_EXISTING_ON_TRIP_CODE;
        }
      }).then((response) {
        print("Response to send to view $response");
        return response;
      });
    }
  }

  joinTrip(feedId, feedData, context) {
    Routes.navigator.pushNamed(
      Routes.joinTrip,
      arguments: JoinTripArguments(
        tripData: feedData,
        tripId: feedId,
        driverId: feedData['sender_uid'],
      ),
    );
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

  Stream<QuerySnapshot> getAllFeeds() {
    return feedsRef
        .where("feed_type", isEqualTo: TripConst.RIDE_OFFER)
        .where("feed_status", isEqualTo: TripConst.ONCOMING_TRIP)
        .where("vehicle_seats_number", isGreaterThan: 0)
        /*
          We need a solution for this, finding a way to
          orderBy date while fetching number of seats greater than zero
          .orderBy("date_updated", descending: true)  
        */
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
        .where("feed_type", isEqualTo: TripConst.INTERESTS)
        .snapshots();
  }

  getTripsByUserId(String userId, String status) {
    return feedsRef
        .orderBy("date_updated", descending: true)
        .where("sender_uid", isEqualTo: userId.trim())
        .where("feed_status", isEqualTo: status.trim())
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
