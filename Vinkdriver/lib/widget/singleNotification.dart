import 'package:Vinkdriver/helper/fcm_notofications.dart';
import 'package:Vinkdriver/routes/routes.gr.dart';
import 'package:Vinkdriver/utils/Utils.dart';
import 'package:Vinkdriver/views/ViewingTrip.dart';
import 'package:Vinkdriver/views/chat/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Vinkdriver/model/helper.dart';
import 'package:Vinkdriver/model/User.dart';

import '../constants.dart';

class SingleNotification extends StatefulWidget {
  var notificationData;
  var notificationId;
  SingleNotification({this.notificationData, this.notificationId});
  @override
  SingleNotificationState createState() => SingleNotificationState();
}

class SingleNotificationState extends State<SingleNotification> {
  @override
  Widget build(BuildContext context) {
    User user = new User();
    var notificationData = widget.notificationData;
    return FutureBuilder(
        future: user.getUserById(notificationData['from_user'], 'passengers'),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center();
          } else {
            if (snapshot.data.exists) {
              var userDetails = snapshot.data.data();
              var notificationType = notificationData['notification_type'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewingTrip(tripId: notificationData['trip_id']),
                    ),
                  );
                },
                child: Material(
                  color: Colors.white,
                  elevation: 0.4,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: notificationType != 'passengerJoinedTrip'
                            ? displayRequestTripNotification(
                                userDetails, notificationType, notificationData)
                            : displayJoinedTripNotification(userDetails,
                                notificationType, notificationData),
                      )),
                ),
              );
            } else {
              return Container();
            }
          }
        });
  }

  displayRequestTripNotification(
      userDetails, notificationType, notificationData) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            radius: 20,
            child: ClipOval(
              child: userDetails.containsKey('profile_pic')
                  ? Image.network(
                      userDetails['profile_pic'].toString(),
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    )
                  : Image.network(
                      defaultPic,
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    ),
            ),
          ),
          title: Text(
            'Requested to join your trip',
            style: TextStyle(
              color: vinkBlack,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            '${userDetails['name']} requested to join your trip ${notificationData['departurePoint']} to ${notificationData['destinationPoint']}',
            style: TextStyle(
              color: vinkDarkGrey,
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                print(notificationData);
                // sendAcceptedMessageToPassenger(notificationData);
              },
              child: Icon(
                Icons.check,
                color: Color(0xFFCC1718),
              ),
              shape: OutlineInputBorder(
                borderSide: BorderSide(color: vinkRed),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            SizedBox(width: 10.0),
            FlatButton(
              onPressed: () {
                Routes.navigator.popAndPushNamed(
                  Routes.profile,
                  arguments: ProfileArguments(
                    userId: Utils.AUTH_USER.uid,
                    userType: UserType.PASSENGER,
                  ),
                );
              },
              child: Text(
                'Profile',
                style: textStyle(16, vinkRed),
              ),
              shape: OutlineInputBorder(
                borderSide: BorderSide(color: vinkRed),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            SizedBox(width: 10.0),
            FlatButton(
              onPressed: () {
                sendRejectMessageToPassenger(notificationData);
              },
              child: Icon(
                Icons.close,
                color: Color(0xFFCC1718),
              ),
              shape: OutlineInputBorder(
                borderSide: BorderSide(color: vinkRed),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ],
        ),
      ],
    );
  }

  displayJoinedTripNotification(
      userDetails, notificationType, notificationData) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            radius: 20,
            child: ClipOval(
              child: userDetails.containsKey('profile_pic')
                  ? Image.network(
                      userDetails['profile_pic'].toString(),
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    )
                  : Image.network(
                      defaultPic,
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    ),
            ),
          ),
          title: Text(
            'Joined your trip',
            style: TextStyle(
              color: vinkBlack,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            '${userDetails['name']} joined your trip ${notificationData['departurePoint']} to ${notificationData['destinationPoint']}',
            style: TextStyle(
              color: vinkDarkGrey,
              fontSize: 16,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                var phoneNumber = 'tel: ${userDetails['phone_number']}';
                Utils.launchURL(phoneNumber);
              },
              child: Icon(
                Icons.call,
                color: Color(0xFFCC1718),
              ),
              shape: OutlineInputBorder(
                borderSide: BorderSide(color: vinkRed),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            SizedBox(width: 10.0),
            RaisedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatMessage(
                      userId: notificationData['from_user'],
                    ),
                  ),
                )
              },
              color: vinkBlack,
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ],
              ),
              shape: OutlineInputBorder(
                borderSide: BorderSide(color: vinkRed),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
