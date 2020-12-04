import 'package:flutter/material.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart';

class Profile extends StatefulWidget {
  final String userId;
  final String userType;
  const Profile({@required this.userId, @required this.userType});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _user = new User();
  Feeds feeds = new Feeds();
  String userId;
  String userType;

  @override
  void initState() {
    userId = widget.userId;
    userType = widget.userType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            'Profile',
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: userType == UserType.DRIVER
                ? _user.getDriver(userId)
                : _user.getPassenger(userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Map user = snapshot.data.data();
                var userId = snapshot.data.id;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 45.0,
                            child: ClipOval(
                              child: SizedBox(
                                height: 100.0,
                                width: 100.0,
                                child: user.containsKey('profile_pic')
                                    ? Image.network(
                                        user['profile_pic'].toString(),
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        defaultPic,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '${user['name']}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                          Text(
                            '${userType == UserType.DRIVER ? 'Toyota - Yaris' : 'Passenger'}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFB3B3B3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 80,
                      margin: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "0.0",
                                        style: TextStyle(
                                          color: Color(0xFF1B1B1B),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      Icon(
                                        Icons.star,
                                        size: 25,
                                        color: Color(0xFFCC1718),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                'Rate',
                                style: TextStyle(
                                  color: Color(0xFFB3B3B3),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder(
                              stream: feeds.getFeedsByUserId(userId),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text('An error occured.'),
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Text(
                                        '${snapshot.data.docs.length < 10 ? '0' : ''}${snapshot.data.docs.length}',
                                        style: TextStyle(
                                          color: Color(0xFF1B1B1B),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Trips',
                                        style: TextStyle(
                                          color: Color(0xFFB3B3B3),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text(
                          "Error occured while trying to get logged in user details!"),
                    ),
                  );
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}
