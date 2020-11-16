import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/utils/utilities.dart';
import 'package:passenger/widgets/displayPassengerList.dart';

class ViewingTrip extends StatefulWidget {
  final String tripId;
  const ViewingTrip({@required this.tripId});
  @override
  _ViewingTripState createState() => _ViewingTripState();
}

class _ViewingTripState extends State<ViewingTrip> {
  Feeds feed = new Feeds();
  User user = new User();
  @override
  Widget build(BuildContext context) {
    var tripId = widget.tripId;

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
          'About Trip',
          style: TextStyle(
            color: Color(0xFF1B1B1B),
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
            future: feed.getFeedById(tripId),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  width: 0,
                  height: 0,
                );
              } else {
                if (snapshot.data.data() != null) {
                  var feedData = snapshot.data.data();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                '${feedData['destination_point']}',
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
                              'Departure Date',
                              style: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontFamily: 'Roboto',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${Utils.formatDateIntoDDMMYY(feedData['departure_datetime'])}',
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
                              '${Utils.getTimeFromFirebaseTimestamp(feedData['departure_datetime'])}',
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
                      SizedBox(height: 10.0),
                      Material(
                        color: Color(0xFFFFFFFF),
                        elevation: 1,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About Car',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF1B1B1B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: FutureBuilder(
                                    future: user
                                        .getUserById(feedData['sender_uid']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                          height: 0,
                                          width: 0,
                                        );
                                      } else {
                                        var userDetails = snapshot.data.data();
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                CircleAvatar(
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      child: Image.network(
                                                        userDetails[
                                                            'profile_pic'],
                                                        height: 80.0,
                                                        width: 80.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                                Text(
                                                  '${userDetails['name']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xFF1B1B1B),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Car Name',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFFCC1718),
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${feedData['vehicle_description']}',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF1B1B1B),
                                                        fontFamily: 'Roboto',
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5.0),
                                                // Column(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.end,
                                                //   children: [
                                                //     Text(
                                                //       'Car Name',
                                                //       style: TextStyle(
                                                //         color: Color(0xFFCC1718),
                                                //         fontFamily: 'Roboto',
                                                //         fontSize: 16,
                                                //       ),
                                                //     ),
                                                //     Text(
                                                //       'Range Rover',
                                                //       style: TextStyle(
                                                //         color: Color(0xFF1B1B1B),
                                                //         fontFamily: 'Roboto',
                                                //         fontSize: 18,
                                                //         fontWeight: FontWeight.bold,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            )
                                          ],
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Material(
                        color: Color(0xFFFFFFFF),
                        elevation: 1,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Passengers list',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF1B1B1B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: DisplayPassengerList(tripId: tripId)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: () => {},
                        color: Color(0xFF1B1B1B),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        child: Text(
                          "Join Trip",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w500),
                        ),
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1B1B1B)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text(
                      "Problem getting Trip Details. Maybe it no longer exist");
                }
              }
            }),
      ),
    );
  }
}
