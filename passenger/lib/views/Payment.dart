import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/helpers/dialogHelper.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/Notifications.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:passenger/services/VinkFirebaseMessagingService.dart';

class Payment extends StatefulWidget {
  final String paymentUrl;
  const Payment({@required this.paymentUrl});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String currentUserId;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedUrl = widget.paymentUrl;
    var baseURL = Constants.PAYMENT_SERVER_ADDRESS;
    currentUserId = auth.currentUser.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFCF9F9),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Trip Payment",
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                      child: WebView(
                    initialUrl: selectedUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    javascriptChannels: <JavascriptChannel>[
                      _toasterJavascriptChannel(context),
                    ].toSet(),
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url
                          .startsWith('$baseURL/payment/paymentSuccess')) {
                        var uri = Uri.dataFromString(request.toString());
                        Map<String, String> params = uri.queryParameters;

                        print("Successfuly paid");
                        print(params);

                        var transactionReference =
                            params['TransactionReference'];
                        var amount = params['Amount'];
                        var tripId = params['Optional1'];
                        var passengerId = params['Optional2'];
                        var driverId = params['Optional3'];

                        _addPassengerToTrip(tripId, driverId, passengerId,
                            transactionReference, amount);

                        return NavigationDecision.prevent;
                      } else if (request.url
                          .startsWith('$baseURL/payment/paymentError')) {
                        var uri = Uri.dataFromString(request.toString());
                        Map<String, String> params = uri.queryParameters;

                        print("Error Payment");
                        print(params);

                        return NavigationDecision.prevent;
                      } else if (request.url
                          .startsWith('$baseURL/payment/paymentCancelation')) {
                        var uri = Uri.dataFromString(request.toString());
                        Map<String, dynamic> params = uri.queryParameters;

                        print("Cancelled Payment");
                        print(params['SiteCode']);
                        _loader("You cancelled the payment.");

                        return NavigationDecision.prevent;
                      }

                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                    },
                    gestureNavigationEnabled: true,
                  )),
                ),
              ],
            )
          ],
        ));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  _loader(message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
            subtitle: Container(
                child: Text(
          message,
          style: TextStyle(
              color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w600),
        ))),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Go home!"),
          )
        ],
      ),
    );
  }

  _addPassengerToTrip(
      tripId, driverId, passengerId, transactionReference, amount) {
    Feeds feed = new Feeds();

    var isLoading = true;
    DialogHelper.loadingDialogWithMessage(context, isLoading, "Loading");

    Map<String, dynamic> newPassangerData = {
      'date_joined': FieldValue.serverTimestamp(),
      'payment_status': PaymentConst.STATUS_PAID,
      'amount_paid': amount,
      'transactionReference': transactionReference,
    };

    feed
        .addPassengerToFeedTrip(tripId, currentUserId, newPassangerData)
        .then((value) {
      print("Results from model $value");
      if (value == TripConst.TRIP_IS_FULL_CODE) {
        _displayResponse(TripConst.TRIP_IS_FULL_STRING);
      } else if (value == TripConst.USER_EXISTING_ON_TRIP_CODE) {
        _displayResponse(TripConst.USER_EXISTING_ON_TRIP_STRING);
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
      'notification_type': TripConst.PASSENGER_JOINED_TRIP,
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
    };

    var messageData = {
      'passengerId': currentUserId,
      'tripId': tripId,
      'notificationType': TripConst.PASSENGER_JOINED_TRIP
    };

    VinkFirebaseMessagingService()
        .buildAndReturnFcmMessageBody(notificationData, messageData, driverId)
        .then((data) {
      setState(() {
        var isLoading = false;
        Navigator.of(context).pop();

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
