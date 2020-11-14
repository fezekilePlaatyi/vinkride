import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vinkdriver/model/Feeds.dart';
import 'package:Vinkdriver/model/Notifications.dart';
import 'package:Vinkdriver/services/VinkFirebaseMessagingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Vinkdriver/helper/Helper.dart';
import 'package:Vinkdriver/helper/dialogHelper.dart';

class PokeUserOnTrip extends StatefulWidget {
  final userIdPoking;
  PokeUserOnTrip({this.userIdPoking});
  @override
  PokeUserOnTripState createState() => PokeUserOnTripState();
}

class PokeUserOnTripState extends State<PokeUserOnTrip> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Feeds feeds = new Feeds();
  var _currentIndex = "no_selection";
  var rideType = "rideOffer";
  bool isLoading = false;

  sendFCMMessage(Map notificationData, Map messageData, String reciever) async {
    VinkFirebaseMessagingService()
        .buildAndReturnFcmMessageBody(notificationData, messageData, reciever)
        .then((data) => {VinkFirebaseMessagingService().sendFcmMessage(data)});
  }

  @override
  Widget build(BuildContext context) {
    var userIdPoking = widget.userIdPoking;
    String currentUserId = auth.currentUser.uid;

    return Scaffold(
        appBar: AppBar(
          title: Text('Select a trip to poke user to.'),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
                stream: feeds.getRidesByUserId(currentUserId, rideType),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var feedsData = snapshot.data.docs.toList();
                    if (feedsData.length > 0)
                      return _displayListOfLoggedInUserRidesOffers(
                          feedsData, userIdPoking);
                    else
                      return Container(
                          alignment: Alignment(.1, -8),
                          child: Text(
                            "No Ride to poke user to!",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ));
                  }
                })));
  }

  _displayListOfLoggedInUserRidesOffers(feedsData, userIdPoking) {
    String currentUserId = auth.currentUser.uid;
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                child: FlatButton(
              child: Text(
                "CANCEL",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              onPressed: () => {Navigator.of(context).pop(true)},
            )),
            Container(
                child: FlatButton(
              child: Text(
                "POKE",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              onPressed: () {
                if (_currentIndex == "no_selection") {
                  return;
                }
                var rideId = _currentIndex;
                DialogHelper.insertPrice(context, rideId, userIdPoking);
              },
            )),
          ]),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: feedsData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var feedData = feedsData[index].data();
                      var departurePoint = feedData['departure_point'];
                      var destinationPoint = feedData['destination_point'];
                      var departureDatetime = DateFormat('dd-MM-yy kk:mm')
                          .format(feedData['departure_datetime'].toDate());

                      return RadioListTile(
                        value: feedsData[index].id,
                        groupValue: _currentIndex,
                        title: Text(
                            "A trip from $departurePoint to $destinationPoint at $departureDatetime"),
                        onChanged: (val) {
                          print(val);
                          setState(() {
                            _currentIndex = val;
                          });
                        },
                        activeColor: Colors.red,
                        selected: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  _loader() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          subtitle: isLoading
              ? Container(
                  height: 50.0,
                  width: 50.0,
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
