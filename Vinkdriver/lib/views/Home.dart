import 'dart:async';

import 'package:Vinkdriver/constants.dart';
import 'package:Vinkdriver/model/Feeds.dart';
import 'package:Vinkdriver/services/VinkFirebaseMessagingService.dart';
import 'package:Vinkdriver/views/CreateTrip.dart';
import 'package:Vinkdriver/views/SearchRide.dart';
import 'package:Vinkdriver/widget/Menu.dart';
import 'package:Vinkdriver/widget/RideRequest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Vinkdriver/model/Helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Feeds feeds = new Feeds();
  var feedType = TripConst.RIDE_REQUEST;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  String currentUserIdAsFCMChannel;

  @override
  void initState() {
    super.initState();
    final FirebaseMessaging _fcm = FirebaseMessaging();

    currentUserIdAsFCMChannel = auth.currentUser.uid;
    VinkFirebaseMessagingService.init(currentUserIdAsFCMChannel);
    print("Channel Id: $currentUserIdAsFCMChannel");

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      var messageData = message['data'];
      var notificationType = messageData['notificationType'];
      print("onMessage Received. Data $messageData");

      if (notificationType == TripConst.TRIP_JOIN_REQUEST) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
                title: Text(
                    "Trip Join Request ${messageData['departure_point']} To ${messageData['destination_point']}"),
                subtitle: Text(
                    "Time: ${messageData['departure_datetime']}. Amount To Pay - ${messageData['amount']}")),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _sendRejectMessageToPassenger(messageData);
                  Navigator.pop(context);
                },
                child: Text("Reject"),
              ),
              FlatButton(
                onPressed: () {
                  new Timer(
                      const Duration(seconds: 1),
                      () => {
                            _sendAcceptedMessageToPassenger(messageData),
                            print("1 second later.")
                          });

                  Navigator.pop(context);
                },
                child: Text("Accept"),
              ),
            ],
          ),
        );
      }
    }, onLaunch: (Map<String, dynamic> message) async {
      print("HEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE onLaucn");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text("Notification"),
          ),
        ),
      );
    }, onResume: (Map<String, dynamic> message) async {
      print("HEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE onResume");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  content: ListTile(
                title: Text("Notification"),
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: SideMenu(),
        ),
        key: _scaffoldKey,
        backgroundColor: Color(0xFFFCF9F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCF9F9),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Ride Requests',
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SearchRide(typeOfRide: 'rideRequest')))
              },
              icon: Icon(
                Icons.search,
                size: 25,
                color: Color(0xFFCC1718),
              ),
            ),
            IconButton(
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
              icon: Icon(
                Icons.menu,
                size: 25,
                color: Color(0xFFCC1718),
              ),
            ),
          ],
        ),
        body: _DriverHome(feedType));
  }

  _sendRejectMessageToPassenger(messageData) {
    var notificationData = {
      'title': "New Notification",
      'body': TripConst.TRIP_REQUEST_REJECTED_STRING
    };
    var passengerId = messageData['driverId'];
    messageData['notificationType'] = TripConst.TRIP_JOIN_ACCEPTED;
    _deliverNotification(notificationData, messageData, passengerId);
  }

  _sendAcceptedMessageToPassenger(messageData) {
    var notificationData = {
      'title': "New Notification",
      'body': TripConst.TRIP_REQUEST_ACCEPTED_STRING
    };
    print(messageData);
    var passengerId = messageData['driverId'];

    messageData['notificationType'] = TripConst.TRIP_JOIN_ACCEPTED;
    _deliverNotification(notificationData, messageData, passengerId);
  }

  _deliverNotification(notificationData, messageData, passengerId) {
    VinkFirebaseMessagingService()
        .buildAndReturnFcmMessageBody(
            notificationData, messageData, passengerId)
        .then((data) => {VinkFirebaseMessagingService().sendFcmMessage(data)});
  }

  _DriverHome(String feedType) {
    return Stack(children: [
      StreamBuilder(
          stream: feeds.getAllFeeds(feedType),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data.docs.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    var feedData = snapshot.data.docs[index].data();
                    var feedId = snapshot.data.docs[index].id;
                    // return Text("Feed data $feedata");
                    return RideRequest(feedData: feedData, feedId: feedId);
                  },
                );
              } else {
                return Container(
                  alignment: Alignment(-0.9, -0.9),
                  child: Text(
                    "No request!",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                );
              }
            }
          }),
      Positioned(
        bottom: 20,
        right: 20,
        child: ButtonTheme(
          minWidth: 60.0,
          height: 60.0,
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CreateTrip()));
            },
            child: Icon(
              FontAwesomeIcons.plus,
              size: 16.0,
              color: Color(0xFFFFFFFF),
            ),
            color: vinkRed,
            shape: OutlineInputBorder(
              borderSide: BorderSide(color: vinkRed),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    ]);
  }
}
