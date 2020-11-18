import 'package:Vinkdriver/views/PokeUserOnTrip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Vinkdriver/helper/Helper.dart';
import 'package:Vinkdriver/model/User.dart';

class RideRequest extends StatefulWidget {
  final feedData;
  final feedId;
  RideRequest({this.feedData, this.feedId});
  @override
  _RideRequestState createState() => _RideRequestState();
}

class _RideRequestState extends State<RideRequest> {
  @override
  Widget build(BuildContext context) {
    var feedData = widget.feedData;
    User user = new User();

    return GestureDetector(
      onTap: () => {},
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Color(0xF5F5F5)),
        ),
        child: Column(
          children: [
            Container(
              child: StreamBuilder(
                  stream: user.getPassenger(feedData['sender_uid']),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(
                          child: Text("Error."),
                        ),
                      );
                    } else {
                      if (snapshot.data.exists) {
                        var userDetails = snapshot.data.data();
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            child: ClipOval(
                              child: SizedBox(
                                height: 80.0,
                                width: 80.0,
                                child: Image.network(
                                  userDetails.containsKey('profile_pic')
                                      ? userDetails['profile_pic']
                                      : defaultPic,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userDetails['name']}',
                                style: TextStyle(
                                  color: Color(0xFF1B1B1B),
                                  fontFamily: 'Roboto',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Passenger',
                                style: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }
                  }),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Material(
                    color: Color(0xFFFFFFFF),
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Color(0xFFCC1718),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${feedData['departure_point']}',
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
                  SizedBox(height: 10),
                  Material(
                    color: Color(0xFFFFFFFF),
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Color(0xFFCC1718),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Destination',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${dateWithDash(feedData['departure_datetime'])}',
                            style: TextStyle(
                              color: Color(0xFF1B1B1B),
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${hoursMinutes(feedData['departure_datetime'])}',
                            style: TextStyle(
                              color: Color(0xFF1B1B1B),
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            const Divider(
              color: Color(0xFFF5F5F5),
              height: 0,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PokeUserOnTrip(
                                  userIdPoking: feedData['sender_uid'])));
                    },
                    color: Color(0xFF1B1B1B),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Text(
                      "Poke Passenger",
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
