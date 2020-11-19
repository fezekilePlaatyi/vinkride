import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/Notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/services/VinkFirebaseMessagingService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NegotiatePrice extends StatefulWidget {
  final rideId, userId, amountWillingToPay, feedData;
  NegotiatePrice(
      {this.rideId, this.userId, this.amountWillingToPay, this.feedData});
  @override
  _NegotiatePriceState createState() => _NegotiatePriceState();
}

class _NegotiatePriceState extends State<NegotiatePrice> {
  final amountAdjustEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var amountAdjust = false;
  var userIdPoking;
  var rideId;
  var amountWillingToPay;
  var feedDataPokedTo;

  @override
  void initState() {
    super.initState();
    amountAdjust = false;
  }

  @override
  void dispose() {
    amountAdjustEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      userIdPoking = widget.userId;
      rideId = widget.rideId;
      amountWillingToPay = widget.amountWillingToPay;
      feedDataPokedTo = widget.feedData;
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildNegotiationDialog(context),
    );
  }

  _buildNegotiationDialog(BuildContext context) => Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "About To Request Trip.",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.0),
            Text("Trip Fare -  R$amountWillingToPay"),
            amountAdjust
                ? TextFormField(
                    decoration: formDecor("Enter units in ZARs"),
                    controller: amountAdjustEditingController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )
                : FlatButton(
                    child: Text(
                      "Negotiate price?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        amountAdjust = true;
                      });
                    },
                  ),
            SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 10.0),
                RaisedButton(
                  onPressed: () {
                    _loader(true);

                    String currentUserId = auth.currentUser.uid;
                    var amountAdjustment =
                        amountAdjustEditingController.text != ""
                            ? amountAdjustEditingController.text
                            : amountWillingToPay;

                    _saveRequestToDatabase(
                        userIdPoking, currentUserId, rideId, amountAdjustment);
                  },
                  child: Text('Submit'),
                  textColor: Colors.white,
                  color: Color(0xFF1B1B1B),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1B1B1B)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(10),
                )
              ],
            )
          ],
        ),
      );

  _saveRequestToDatabase(
      userIdOfTripOwner, currentUserId, rideId, amountAdjustment) {
    Notifications notifications = new Notifications();

    Map<String, dynamic> notificationDataToDB = {
      'date_created': FieldValue.serverTimestamp(),
      'to_user': userIdOfTripOwner,
      'from_user': currentUserId,
      'is_seen': false,
      'amount': amountAdjustment,
      'notification_type': 'requestToJoingTrip',
      'trip_id': rideId,
      'departurePoint': feedDataPokedTo['departure_point'],
      'destinationPoint': feedDataPokedTo['destination_point'],
      'departureDatetime': DateFormat('dd-MM-yy kk:mm')
          .format(feedDataPokedTo['departure_datetime'].toDate())
    };

    notifications
        .addNewNotification(notificationDataToDB, userIdOfTripOwner)
        .then((value) {
      _sendNotification(
          currentUserId, rideId, userIdOfTripOwner, amountAdjustment);
      Navigator.of(context).pop();
      _loader(false);
    });
  }

  _sendNotification(String currentUserId, String rideId,
      String userIdOfTripOwner, String amountAdjustment) {
    var notificationData = {
      'title': "New Notification",
      'body':
          "A Passenger requested to join your Trip, click here for more details.",
      'notificationType': 'requestToJoingTrip'
    };

    var messageData = {
      'passengerId': currentUserId,
      'notificationType': 'requestToJoingTrip',
      'amount': amountAdjustment,
      'trip_id': rideId,
      'departurePoint': feedDataPokedTo['departure_point'],
      'destinationPoint': feedDataPokedTo['destination_point'],
      'departureDatetime': DateFormat('dd-MM-yy kk:mm')
          .format(feedDataPokedTo['departure_datetime'].toDate())
    };

    VinkFirebaseMessagingService()
        .buildAndReturnFcmMessageBody(
            notificationData, messageData, userIdOfTripOwner)
        .then((data) => {VinkFirebaseMessagingService().sendFcmMessage(data)});
  }

  _loader(bool isLoading) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: isLoading
              ? Container(
                  height: 100.0,
                  width: 80.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Text("Request sent!"),
          subtitle: isLoading
              ? Container(height: 0)
              : Text("Please wait for trip owner's response."),
        ),
        actions: <Widget>[
          isLoading
              ? SizedBox.shrink()
              : FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Got It!"),
                )
        ],
      ),
    );
  }
}
