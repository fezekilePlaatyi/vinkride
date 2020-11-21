import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/Notifications.dart';
import 'package:passenger/services/VinkFirebaseMessagingService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinTrip extends StatefulWidget {
  final String tripId;
  final String driverId;
  final Map tripData;
  final String paymentToken;
  const JoinTrip(
      {@required this.tripId,
      @required this.driverId,
      @required this.tripData,
      this.paymentToken});
  @override
  JoinTripState createState() => JoinTripState();
}

class JoinTripState extends State<JoinTrip> {
  bool isLoading = false;

  final pickUpPointEditingController = TextEditingController();
  final destinationEditingController = TextEditingController();

  setSharedPreferencesTripData(Map<dynamic, dynamic> tripData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('tripData', tripData.toString());
  }

  @override
  void dispose() {
    pickUpPointEditingController.dispose();
    destinationEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserId = auth.currentUser.uid;
    var tripId = widget.tripId;
    var paymentToken = widget.paymentToken;
    var driverId = widget.driverId;
    var tripData = widget.tripData;
    Notifications notifications = new Notifications();
    Feeds feed = new Feeds();
    var title = 'Joining Trip';

    if (paymentToken == 'willDoOncePayment') {
      //should change button name to pay with card
    }

    return Scaffold(
      backgroundColor: Color(0xFFFCF9F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF9F9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Color(0xFFCC1718),
            size: 30.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF1B1B1B),
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
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
                      '${tripData['destination_point']}',
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
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${tripData['departure_point']}',
                    style: TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure Date',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${DateFormat('dd-MM-yy').format(tripData['departure_datetime'].toDate())}',
                    style: TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure Time',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${DateFormat('kk:mm').format(tripData['departure_datetime'].toDate())}',
                    style: TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fare',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'R${tripData['trip_fare']}',
                    style: TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                width: 300, // specific value
                child: RaisedButton(
                    color: Colors.black87,
                    child: GestureDetector(
                      child: Text(
                        'Confirm Joining Trip',
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    textColor: Colors.white,
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(15),
                    onPressed: () {}),
              ),
            )
          ],
        ),
      ),
    );
  }
}
