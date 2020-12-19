import 'dart:convert';
import 'package:Vinkdriver/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/model/Notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vinkdriver/services/VinkFirebaseMessagingService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NegotiatePrice extends StatefulWidget {
  final String rideId;
  final Map feedData;
  final String userIdPoking;
  final String actionType;
  const NegotiatePrice(
      {this.rideId, this.feedData, this.userIdPoking, this.actionType});
  @override
  _NegotiatePriceState createState() => _NegotiatePriceState();
}

class _NegotiatePriceState extends State<NegotiatePrice> {
  final amountAdjustEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var amountAdjust = false;
  var rideId;
  var feedData;
  var userIdPoking;
  var actionType;

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
      rideId = widget.rideId;
      feedData = widget.feedData;
      userIdPoking = widget.userIdPoking;
      actionType = widget.actionType;
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
              "About To Poke User.",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.0),
            Text("Willing to pay -  R${feedData['trip_fare']}"),
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

                    var amountAdjustment =
                        amountAdjustEditingController.text != ""
                            ? amountAdjustEditingController.text
                            : feedData['trip_fare'];

                    _saveRequestToDatabase(amountAdjustment);
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

  _saveRequestToDatabase(amountAdjustment) {
    Notifications notifications = new Notifications();
    String currentUserId = auth.currentUser.uid;

    Map<String, dynamic> notificationDataToDB = {
      'date_created': FieldValue.serverTimestamp(),
      'to_user': userIdPoking,
      'from_user': currentUserId,
      'is_seen': false,
      'amount': amountAdjustment,
      'notification_type': TripConst.PASSENGER_POKED_TRIP,
      'trip_id': rideId,
      'departurePoint': feedData['departure_point'],
      'destinationPoint': feedData['destination_point'],
      'departureDatetime': DateFormat('dd-MM-yy kk:mm')
          .format(feedData['departure_datetime'].toDate())
    };

    notifications
        .addNewNotification(notificationDataToDB, feedData['sender_uid'])
        .then((value) {
      _sendNotification(currentUserId, amountAdjustment);
      Navigator.of(context).pop();
      _loader(false);
    });
  }

  _sendNotification(currentUserId, amountAdjustment) {
    var notificationData = {
      'title': "New Notification",
      'body': TripConst.TRIP_POKED_STRING,
    };

    var messageData = {
      'passengerId': currentUserId,
      'to_user': userIdPoking,
      'notificationType': TripConst.PASSENGER_POKED_TRIP,
      'amount': amountAdjustment,
      'trip_id': rideId,
      'departurePoint': feedData['departure_point'],
      'destinationPoint': feedData['destination_point'],
      'departureDatetime': DateFormat('dd-MM-yy kk:mm')
          .format(feedData['departure_datetime'].toDate())
    };

    print('Owner ${feedData['sender_uid']} Current $currentUserId');

    VinkFirebaseMessagingService()
        .buildAndReturnFcmMessageBody(
            notificationData, messageData, userIdPoking)
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
              : Text("Poked successfuly!"),
          subtitle: isLoading
              ? Container(height: 0)
              : Text("Please wait for passenger's response."),
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
