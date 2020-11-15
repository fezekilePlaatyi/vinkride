import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/utils/utilities.dart';

class DisplayPassengerList extends StatefulWidget {
  final tripId;
  DisplayPassengerList({this.tripId});
  @override
  DisplayPassengerListState createState() => DisplayPassengerListState();
}

class DisplayPassengerListState extends State<DisplayPassengerList> {
  Feeds feed = new Feeds();
  User user = new User();
  @override
  Widget build(BuildContext context) {
    var tripId = widget.tripId;
    return StreamBuilder(
        stream: feed.getFeedPassengersById(tripId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var feedDataPassengerDocs = snapshot.data.docs;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: feedDataPassengerDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  var feedPassengerData = feedDataPassengerDocs[index].data();
                  var feedPassengerId = feedDataPassengerDocs[index].id;
                  return FutureBuilder(
                      future: user.getUserById(feedPassengerId),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        } else {
                          var userDetails = snapshot.data.data();
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(children: [
                                  Text(
                                    '${userDetails['name']}',
                                    style: TextStyle(
                                      color: Color(0xFF1B1B1B),
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]),
                                Column(children: [
                                  Center(
                                    child: FlatButton(
                                      onPressed: () {
                                        Utils.launchURL(
                                            "https://www.google.com/maps/dir//${feedPassengerData['pick_up_point']}");
                                      },
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(Icons.directions_car_rounded),
                                        ],
                                      ),
                                    ),
                                  )
                                ])
                              ]);
                        }
                      });
                });
          }
        });
  }
}
