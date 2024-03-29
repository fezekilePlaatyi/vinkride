import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Vinkdriver/model/Feeds.dart';
import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/model/User.dart';

class DisplayPassengerList extends StatefulWidget {
  final String tripId;
  const DisplayPassengerList({this.tripId});
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
            return CircularProgressIndicator();
          } else {
            if (snapshot.data.docs.length > 0) {
              print('Testing');
              var feedDataPassengerDocs = snapshot.data.docs;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: feedDataPassengerDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var feedPassengerData = feedDataPassengerDocs[index].data();
                    var feedPassengerId = feedDataPassengerDocs[index].id;
                    return StreamBuilder(
                        stream: user.getPassenger(feedPassengerId),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              height: 0,
                              width: 0,
                            );
                          } else {
                            var userDetails = snapshot.data.data();

                            if (userDetails != null) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  ]);
                            } else {
                              return Container(
                                height: 0,
                                width: 0,
                              );
                            }
                          }
                        });
                  });
            }
            return Container(
              child: Text('No one yet!!'),
            );
          }
        });
  }
}
