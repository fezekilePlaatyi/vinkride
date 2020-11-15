import 'package:Vinkdriver/model/Helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vinkdriver/model/Feeds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  Widget build(BuildContext context) {
    var userIdPoking = widget.userIdPoking;
    String currentUserId = auth.currentUser.uid;

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
        title: Text(
          'Poke To Trip',
          style: TextStyle(
            color: vinkBlack,
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder(
          stream: feeds.getRidesByUserId(currentUserId, rideType),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  _displayListOfLoggedInUserRidesOffers(feedsData, userIdPoking) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                ),
              ),
            ],
          ),
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

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: _myScheduledTrips(
                          departurePoint,
                          destinationPoint,
                          departureDatetime,
                          userIdPoking,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  Widget _myScheduledTrips(departure, destination, departureDate, pokeId) {
    return Material(
      elevation: 0.2,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      color: Colors.white,
      child: ListTile(
        title: Text(
          '$departure to $destination',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
            color: vinkBlack,
            fontFamily: 'roboto',
          ),
        ),
        subtitle: Text(
          departureDate,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
            color: vinkDarkGrey,
            fontFamily: 'roboto',
          ),
        ),
        trailing: RaisedButton(
          color: vinkBlack,
          onPressed: () {
            if (_currentIndex == "no_selection") {
              return;
            }
            var rideId = _currentIndex;
            DialogHelper.insertPrice(context, rideId, pokeId);
          },
          child: Text(
            'Poke',
            style: textStyle(16.0, Colors.white),
          ),
          shape: darkButton(),
        ),
      ),
    );
  }

  _loader() {
    var isLoading;
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
