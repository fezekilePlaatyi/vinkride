import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart' as VinkUser;
import 'package:passenger/widgets/JoinTrip.dart';

class Trip {
  VinkUser.User user = new VinkUser.User();
  String currentUserId = FirebaseAuth.instance.currentUser.uid;

  joinTrip(feedId, feedData, context) {
    user.getUserById(currentUserId).then((documentSnapshot) {
      var userDetails = documentSnapshot.data();
      if (userDetails.containsKey('token_for_recurring_payment') &&
          userDetails['token_for_recurring_payment'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JoinTrip(
              tripId: feedId,
              driverId: feedData['sender_uid'],
              tripData: feedData,
              paymentToken: userDetails['token_for_recurring_payment'],
            ),
          ),
        );
      } else {
        // alertDialogOnNoCardAdded(context);
      }
    });
  }
}
