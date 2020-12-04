import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/helpers/dialogHelper.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/Trip.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/utils/Utils.dart';

class DriverFeed extends StatefulWidget {
  final Map feedData;
  final String feedId;
  const DriverFeed({this.feedData, this.feedId});
  @override
  DriverFeedState createState() => DriverFeedState();
}

class DriverFeedState extends State<DriverFeed> {
  var feedData;
  var feedId;
  var currentUserId;
  Trip trip = new Trip();

  @override
  void initState() {
    feedData = widget.feedData;
    feedId = widget.feedId;
    currentUserId = Utils.AUTH_USER.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = new User();
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: Color(0xF5F5F5)),
      ),
      child: StreamBuilder(
          stream: user.getDriver(feedData['sender_uid']),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 0,
                width: 0,
              );
            } else {
              if (snapshot.data.exists) {
                var userDetails = snapshot.data.data();
                return GestureDetector(
                  onTap: () {
                    Routes.navigator
                        .pushNamed(Routes.viewingTrip, arguments: feedId);
                  },
                  child: Column(
                    children: [
                      driverDetails(userDetails),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          children: [
                            fromPoint(),
                            SizedBox(
                              height: 10,
                            ),
                            destinationPoint(),
                            SizedBox(height: 20),
                            departureDate(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      const Divider(
                        color: Color(0xFFF5F5F5),
                        height: 0,
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFFF2F2F2),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: SizedBox(
                                          height: 50.0,
                                          width: 50.0,
                                          child: Image.network(
                                            defaultPic,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 40),
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${feedData['vehicle_seats_number']} seats empty',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            joinTripButton(feedData),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }
          }),
    );
  }

  Widget driverDetails(userDetails) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          Routes.navigator.pushNamed(
            Routes.profile,
            arguments: ProfileArguments(
              userId: feedData['sender_uid'].toString(),
              userType: UserType.DRIVER,
            ),
          );
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25.0,
          child: ClipOval(
            child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: userDetails.containsKey('profile_pic')
                  ? Image.network(
                      userDetails['profile_pic'].toString(),
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      defaultPic,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${userDetails['name']}',
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            feedData['vehicle_description'] != null
                ? '${feedData['vehicle_description']}'
                : 'No specified',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontFamily: 'Roboto',
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget fromPoint() {
    return Material(
      color: Color(0xFFFFFFFF),
      elevation: 1,
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          size: 40,
          color: Color(0xFFCC1718),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From',
              style: labelStyle(),
            ),
            Text(
              '${feedData['departure_point']}',
              style: TextStyle(
                color: Color(0xFF1B1B1B),
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget destinationPoint() {
    return Material(
      color: Color(0xFFFFFFFF),
      elevation: 1,
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          size: 40,
          color: Color(0xFFCC1718),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Destination',
              style: labelStyle(),
            ),
            Text(
              '${feedData['destination_point']}',
              style: TextStyle(
                color: Color(0xFF1B1B1B),
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget departureDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date',
              style: labelStyle(),
            ),
            Text(
              '${dateWithDash(feedData['departure_datetime'])}',
              style: textStyle(),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Time',
              style: labelStyle(),
            ),
            Text(
              '${hoursMinutes(feedData['departure_datetime'])}',
              style: textStyle(),
            ),
          ],
        ),
      ],
    );
  }

  Widget joinTripButton(feedData) {
    return RaisedButton(
      onPressed: () {
        var userIdRequesting = currentUserId;
        DialogHelper.insertPrice(context, feedId, feedData);
      },
      color: Color(0xFF1B1B1B),
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Text(
        "Join Trip",
        style: TextStyle(
            fontSize: 16,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500),
      ),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF1B1B1B)),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  // _JoinTripRequest() {
  //   _sendNotification(String currentUserId, String rideId, String userIdPoking,
  //       String amountAdjustment) {
  //     var notificationData = {
  //       'title': "New Notification",
  //       'body':
  //           "A Passenger requested to join your Trip, click here for more details.",
  //       'notificationType': 'requestToJoinTrip'
  //     };

  //     var messageData = {
  //       'passengerId': currentUserId,
  //       'notificationType': 'requestToJoinTrip',
  //       'amount': amountAdjustment,
  //       'trip_id': rideId,
  //       'departurePoint': feedDataPokedTo['departure_point'],
  //       'destinationPoint': feedDataPokedTo['destination_point'],
  //       'departureDatetime': DateFormat('dd-MM-yy kk:mm')
  //           .format(feedDataPokedTo['departure_datetime'].toDate())
  //     };

  //     VinkFirebaseMessagingService()
  //         .buildAndReturnFcmMessageBody(
  //             notificationData, messageData, userIdPoking)
  //         .then(
  //             (data) => {VinkFirebaseMessagingService().sendFcmMessage(data)});
  //   }
  // }

  TextStyle labelStyle() {
    return TextStyle(
      color: Color(0xFF9E9E9E),
      fontFamily: 'Roboto',
      fontSize: 16,
    );
  }

  TextStyle textStyle() {
    return TextStyle(
      color: Color(0xFF1B1B1B),
      fontFamily: 'Roboto',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }
}
