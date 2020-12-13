import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/helpers/dialogHelper.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/Notifications.dart';
import 'package:passenger/services/VinkFirebaseMessagingService.dart';
import 'package:passenger/widgets/driverFeed.dart';
import 'package:passenger/widgets/menu.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/models/Payment.dart';
import 'package:passenger/models/User.dart' as VinkUser;
import 'package:passenger/views/Payment.dart' as View;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = auth.currentUser.uid;
    _firebaseCloudHandler();
  }

  @override
  Widget build(BuildContext context) {
    Feeds feeds = new Feeds();
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    EdgeInsets devicePadding = MediaQuery.of(context).viewPadding;
    return Padding(
      padding: devicePadding,
      child: Scaffold(
        drawer: Drawer(
          child: SideMenu(),
        ),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xFFFCF9F9),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Active Trips',
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Routes.navigator.pushNamed(Routes.searchRide);
              },
              icon: Icon(
                Icons.search,
                size: 25,
                color: Color(0xFFCC1718),
              ),
            ),
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 25,
                color: Color(0xFFCC1718),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFCF9F9),
        body: Stack(
          children: [
            StreamBuilder(
                stream: feeds.getAllFeeds(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return loader();
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

                          return DriverFeed(feedData: feedData, feedId: feedId);
                        },
                      );
                    }
                    return Container(
                        alignment: Alignment(.04, -0.9),
                        child: Text(
                          "No trips!",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ));
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
                    Routes.navigator.pushNamed(Routes.createTrip);
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
            )
          ],
        ),
      ),
    );
  }

  _firebaseCloudHandler() {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    VinkFirebaseMessagingService.init(currentUserId);
    print("Channel ID: $currentUserId");

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      var messageData = message['data'];
      var notificationType = messageData['notificationType'];
      print("onMessage Received. Data ${notificationType.toString()}");

      if (notificationType == 'pokedToJoinTrip') {
        _pokeHandler(messageData);
      } else if (notificationType == 'rejectedToJoinTrip') {
        _joingTripRequestDeclineHandler(messageData);
      } else if (notificationType == 'acceptedToJoinTrip') {
        _requestAcceptedHandler(messageData);
      } else {}
    }, onLaunch: (Map<String, dynamic> message) async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text("Notification"),
          ),
        ),
      );
    }, onResume: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  content: ListTile(
                title: Text("Notification"),
              )));
    });
  }

  _requestAcceptedHandler(messageData) {
    print(messageData);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
              "Accepted to joing Trip - ${messageData['departurePoint']} To ${messageData['destinationPoint']}"),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _prepareToGoToPayment(messageData);
            },
            child: Text("Procced to pay."),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Got It!"),
          ),
        ],
      ),
    );
  }

  _prepareToGoToPayment(messageData) {
    var isLoading = true;
    DialogHelper.loadingDialogWithMessage(context, isLoading, "Loading");
    VinkUser.User user = new VinkUser.User();

    user.getUserForCheck().then((user) {
      var transactionReference = DateTime.now().millisecondsSinceEpoch;
      var customer = "V - ${user['name']}";

      Map<String, String> paymentCheckoutData = {
        "TransactionReference": transactionReference.toString(),
        "Customer": customer,
        "Amount":
            double.parse(messageData['amount']).toStringAsFixed(2).toString(),
        "Optional1": messageData['trip_id'].toString(),
        "Optional2": messageData['passengerId'].toString(),
        "Optional3": messageData['driverId'].toString(),
      };

      Payment payment = new Payment();
      payment.prepareCheckout(paymentCheckoutData).then((data) {
        print(data);
        Map<dynamic, dynamic> paymentCheckoutResponse = json.decode(data);

        if (paymentCheckoutResponse.containsKey("url")) {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => View.Payment(
                      paymentUrl: paymentCheckoutResponse['url'])));
        } else {
          print(paymentCheckoutResponse['error']);
          _displayResponse(paymentCheckoutResponse['error'].toString());
        }
      });
    }).catchError((onError) {
      _displayResponse("Error getting your details.");
    });
  }

  _pokeHandler(messageData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
            title: Text(
                "Poked to join a trip ${messageData['departurePoint']} To ${messageData['destinationPoint']}"),
            subtitle: Text(
                "Time: ${messageData['departureDatetime']}. Fare - ${messageData['amount']}")),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No thanks"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              // _addPassengerToTrip(tripId, driverId)
            },
            child: Text("Accept"),
          ),
        ],
      ),
    );
  }

  _joingTripRequestDeclineHandler(messageData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
              "Request Rejected - ${messageData['departurePoint']} To ${messageData['destinationPoint']}"),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Got It!"),
          ),
        ],
      ),
    );
  }

  _addPassengerToTrip(tripId, driverId) {
    Feeds feed = new Feeds();

    var isLoading = true;
    DialogHelper.loadingDialogWithMessage(context, isLoading, "Loading");

    Map<String, dynamic> newPassangerData = {
      'date_joined': FieldValue.serverTimestamp(),
      'payment_status': PaymentConst.STATUS_PAID,
    };

    feed
        .addPassengerToFeedTrip(tripId, currentUserId, newPassangerData)
        .then((value) {
      print("Results from model $value");
      if (value == TripConst.TRIP_IS_FULL_CODE) {
        _displayResponse("Sorry, the Trip is full!");
      } else if (value == TripConst.USER_EXISTING_ON_TRIP_CODE) {
        _displayResponse("Sorry, you are already on this trip!");
      } else {
        _addNotificationToDb(tripId, driverId);
      }
    });
  }

  _addNotificationToDb(tripId, driverId) async {
    Notifications notifications = new Notifications();
    Map<String, dynamic> notificationDataToDB = {
      'date_created': FieldValue.serverTimestamp(),
      'to_user': currentUserId,
      'is_seen': false,
      'notification_type': NotificationsConst.PASSENGER_JOINED_TRIP,
      'from_user': currentUserId,
      'trip_id': tripId,
    };

    notifications
        .addNewNotification(notificationDataToDB, driverId)
        .then((value) {
      _notifyUser(tripId, driverId, currentUserId);
    });
  }

  _notifyUser(tripId, driverId, currentUserId) {
    var notificationData = {
      'title': "New Notification",
      'body': "A Passenger has Joined your Trip, click here for more details.",
      'notificationType': 'passengerJoinedTrip'
    };

    var messageData = {
      'passengerId': currentUserId,
      'tripId': tripId,
      'notificationType': NotificationsConst.PASSENGER_JOINED_TRIP
    };

    VinkFirebaseMessagingService()
        .buildAndReturnFcmMessageBody(notificationData, messageData, driverId)
        .then((data) {
      setState(() {
        var isLoading = false;
        DialogHelper.loadingDialogWithMessage(context, isLoading,
            'Successfuly joined trip and made done trip fare charges!');
      });
    });
  }

  _displayResponse(message) {
    setState(() {
      var isLoading = false;
      DialogHelper.loadingDialogWithMessage(context, isLoading, message);
    });
  }
}
