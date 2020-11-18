import 'package:Vinkdriver/constants.dart';
import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vinkdriver/model/Feeds.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Vinkdriver/helper/dialogHelper.dart';

class PokeUserOnTrip extends StatefulWidget {
  final String userIdPoking;
  const PokeUserOnTrip({this.userIdPoking});
  @override
  PokeUserOnTripState createState() => PokeUserOnTripState();
}

class PokeUserOnTripState extends State<PokeUserOnTrip> {
  Feeds feeds = new Feeds();

  @override
  Widget build(BuildContext context) {
    var userIdPoking = widget.userIdPoking;
    String currentUserId = Utils.AUTH_USER.uid;

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
          stream: feeds.getRidesByUserId(currentUserId, TripConst.RIDE_OFFER),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print('Testing ${snapshot.data.docs}');
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
                      var feedId = feedsData[index].id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: _myScheduledTrips(feedId, feedData),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  Widget _myScheduledTrips(feedId, feedData) {
    var departure = feedData['departure_point'];
    var destination = feedData['destination_point'];
    var departureDate = DateFormat('dd-MM-yy kk:mm')
        .format(feedData['departure_datetime'].toDate());

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
            DialogHelper.insertPrice(context, feedId, feedData);
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

  
}
