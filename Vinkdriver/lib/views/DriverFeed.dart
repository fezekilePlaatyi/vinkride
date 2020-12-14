import 'package:Vinkdriver/views/ViewingTrip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vinkdriver/model/Trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Vinkdriver/helper/Helper.dart';
import 'package:Vinkdriver/model/User.dart' as VinkUser;

class DriverFeed extends StatefulWidget {
  final Map feedData;
  final String feedId;
  const DriverFeed({this.feedData, this.feedId});
  @override
  _DriverFeedState createState() => _DriverFeedState();
}

class _DriverFeedState extends State<DriverFeed> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  VinkUser.User user = new VinkUser.User();
  var feedData;
  var feedId;
  var currentUserId;
  Trip trip = new Trip();

  @override
  void initState() {
    feedData = widget.feedData;
    feedId = widget.feedId;
    currentUserId = auth.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: Color(0xF5F5F5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: user.getUserById(feedData['sender_uid'], 'drivers'),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 0,
                  width: 0,
                );
              } else {
                var userDetails = snapshot.data.data();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewingTrip(tripId: feedId),
                      ),
                    );
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
                                  FutureBuilder(
                                      future: user.getUserById(
                                          feedData['sender_uid'], 'passenger'),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container(
                                            height: 0,
                                            width: 0,
                                          );
                                        } else {
                                          var userDetails =
                                              snapshot.data.data();
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xFFF2F2F2),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                            ),
                                            child: CircleAvatar(
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
                                          );
                                        }
                                      }),
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
                                    child: Expanded(
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
                                  ),
                                ],
                              ),
                            ),
                            joinTripButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget driverDetails(userDetails) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        child: ClipOval(
          child: SizedBox(
            height: 80.0,
            width: 80.0,
            child: Image.network(
              userDetails.containsKey('profile_pic')
                  ? userDetails['profile_pic']
                  : defaultPic,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
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
            '${feedData['vehicle_description']}',
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

  Widget joinTripButton() {
    return RaisedButton(
      onPressed: () {
        print("Joining");
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
