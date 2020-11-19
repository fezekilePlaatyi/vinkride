import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/models/DynamicLinks.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/services/DeviceLocation.dart';
import 'package:passenger/utils/Utils.dart';

class UserTrips extends StatefulWidget {
  final String feedStatus;
  final BuildContext parentContext;
  const UserTrips({this.feedStatus, this.parentContext});
  @override
  UserTripsState createState() => UserTripsState();
}

class UserTripsState extends State<UserTrips> {
  Feeds feeds = new Feeds();
  DynamicLinks links = new DynamicLinks();
  DeviceLocation deviceLocation = new DeviceLocation();

  @override
  Widget build(BuildContext context) {
    String currentUserId = Utils.AUTH_USER.uid;
    String feedStatus = widget.feedStatus;
    var parentContext = widget.parentContext;

    return StreamBuilder(
        stream: feeds.getTripsByUserId(currentUserId, feedStatus),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        var feedData = snapshot.data.docs[index].data();
                        var feedId = snapshot.data.docs[index].id;

                        return Card(
                            elevation: 0.1,
                            color: Colors.white,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Trip",
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(children: [
                                          Text(
                                            "Date: ${DateFormat('dd-MM-yy').format(feedData['departure_datetime'].toDate())}",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            "Time: ${Utils.getTimeFromFirebaseTimestamp(feedData['departure_datetime'])}",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ])
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.share,
                                                color: Color(0xFFCC1718),
                                                size: 30.0,
                                              ),
                                              tooltip:
                                                  'Share your location to other apps.',
                                              onPressed: () {
                                                var position = deviceLocation
                                                    .getCurrentPosition();

                                                position.then((latLong) {
                                                  _shareLocation(
                                                      latLong, parentContext);
                                                });
                                              },
                                            )
                                          ]),
                                          Column(children: [
                                            feedStatus == TripConst.ACTIVE_TRIP
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.stop,
                                                      color: Color(0xFFCC1718),
                                                      size: 30.0,
                                                    ),
                                                    tooltip: 'End trip.',
                                                    onPressed: () {
                                                      feeds
                                                          .updateFeedStatusById(
                                                              feedId, 'closed');
                                                    },
                                                  )
                                                : Text(''),
                                            feedStatus ==
                                                    TripConst.ONCOMING_TRIP
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      color: Color(0xFFCC1718),
                                                      size: 30.0,
                                                    ),
                                                    tooltip: 'Cancel trip.',
                                                    onPressed: () {
                                                      print("OnCancel trip");
                                                    },
                                                  )
                                                : Text(''),
                                          ])
                                        ])
                                  ]),
                            ));
                      }));
            } else {
              return Container(
                  alignment: Alignment(-0.9, -0.9),
                  child: Text(
                    "0 $feedStatus trips :)",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ));
            }
          }
        });
  }

  _shareLocation(latLong, parentContext) {
    // Share share = new Share(parentContext);
    // var url =
    //     Constants.GOOGLE_MAPS_URL + "${latLong.latitude}, ${latLong.longitude}";

    // links.createDynamicLink(url).then((response) {
    //   share.shareText(
    //       '${Constants.VINK_USER_LOCATION_SUBJECT} ${response['shortLink']}',
    //       '');
    // });
  }
}
