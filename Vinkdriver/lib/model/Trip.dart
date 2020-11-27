import 'package:Vinkdriver/model/User.dart' as VinkUser;
import 'package:firebase_auth/firebase_auth.dart';

class Trip {
  VinkUser.User _user;
  String currentUserId = FirebaseAuth.instance.currentUser.uid;

  joinTrip(feedId, feedData, context) {
    _user.getUserById(currentUserId, 'passenger').then((documentSnapshot) {
      var userDetails = documentSnapshot.data();
      if (userDetails.containsKey('token_for_recurring_payment') &&
          userDetails['token_for_recurring_payment'] != null) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => JoinTrip(
        //       tripId: feedId,
        //       driverId: feedData['sender_uid'],
        //       tripData: feedData,
        //       paymentToken: userDetails['token_for_recurring_payment'],
        //     ),
        //   ),
        // );
      } else {
        // alertDialogOnNoCardAdded(context);
      }
    });
  }
}
