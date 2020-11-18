import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:passenger/models/Helper.dart';
=======
import 'package:passenger/models/helper.dart';
>>>>>>> main
import 'package:passenger/models/Notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/services/VinkFirebaseMessagingService.dart';
import 'package:passenger/utils/Utils.dart';

class NegotiatePrice extends StatefulWidget {
  final rideId, userId;
  NegotiatePrice({this.rideId, this.userId});
  @override
  _NegotiatePriceState createState() => _NegotiatePriceState();
}

class _NegotiatePriceState extends State<NegotiatePrice> {
  final amountAdjustEditingController = TextEditingController();
  var amountAdjust = false;
  var userIdPoking;
  var rideId;

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
            amountAdjust
                ? TextFormField(
                    decoration: formDecor("Enter units in ZARs"),
                    controller: amountAdjustEditingController,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )
                : FlatButton(
                    child: Text(
                      "Adjust money?",
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
                    // ;
                    // isLoading = true;
                    _loader(true);

                    String currentUserId = Utils.AUTH_USER.uid;
                    var amountAdjustment = amountAdjustEditingController.text;
                    _savePokeToDatabase(
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

  _savePokeToDatabase(String userIdPoking, String currentUserId, String rideId,
      String amountAdjustment) {
    Notifications notifications = new Notifications();

    Map<String, dynamic> notificationDataToDB = {
      'date_created': FieldValue.serverTimestamp(),
      'to_user': userIdPoking,
      'from_user': currentUserId,
      'is_seen': false,
      'amount': amountAdjustment,
      'notification_type': 'pokedToJoinTrip',
      'trip_id': rideId
    };

    print(notificationDataToDB);

    notifications
        .addNewNotification(notificationDataToDB, userIdPoking)
        .then((value) {
      _sendNotification(currentUserId, rideId, userIdPoking, amountAdjustment);
      Navigator.of(context).pop();
      _loader(false);
    });
  }

  _sendNotification(String currentUserId, String rideId, String userIdPoking,
      String amountAdjustment) {
    var notificationData = {
      'title': "New Notification",
      'body':
          "A Driver has poked you to avaliable Trip, click here for more details.",
      'notificationType': 'pokedToJoinTrip'
    };

    var messageData = {
      'driverId': currentUserId,
      'notificationType': 'pokedToJoinTrip',
      'amount': amountAdjustment,
      'trip_id': rideId
    };

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
          subtitle: isLoading
              ? Container(
                  height: 100.0,
                  width: 80.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Text("Poked successfuly!"),
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
