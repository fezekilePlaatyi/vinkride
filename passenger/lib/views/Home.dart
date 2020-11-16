import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/services/VinkFirebaseMessagingService.dart';
import 'package:passenger/views/createTrip.dart';
import 'package:passenger/views/SearchRide.dart';
import 'package:passenger/widgets/driverFeed.dart';
import 'package:passenger/widgets/menu.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final FirebaseMessaging _fcm = FirebaseMessaging();

    String currentUserIdAsFCMChannel = auth.currentUser.uid;
    VinkFirebaseMessagingService.init(currentUserIdAsFCMChannel);
    print("CHANNEL ID: $currentUserIdAsFCMChannel");

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      var messageData = message['data'];
      var notificationType = messageData['notificationType'];
      print("onMessage Received. Data ${notificationType.toString()}");

      if (notificationType == 'pokedToJoinTrip') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text("Poked"),
            ),
          ),
        );
      }
    }, onLaunch: (Map<String, dynamic> message) async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text("Notification"),
          ),
        ),
      );
    }, onResume: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  content: ListTile(
                title: Text("Notification"),
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    Feeds feeds = new Feeds();
    var feedType = 'rideOffer';
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: Drawer(
        child: SideMenu(),
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF9F9),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Active Trips',
          style: TextStyle(
            color: Color(0xFF1B1B1B),
            fontFamily: 'Roboto',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchRide(),
                ),
              )
            },
            icon: Icon(
              Icons.search,
              size: 25,
              color: Color(0xFFCC1718),
            ),
          ),
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              size: 25,
              color: Color(0xFFCC1718),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFFCF9F9),
      body: StreamBuilder(
          stream: feeds.getAllFeeds(feedType),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: Stack(
                  children: [
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            var feedData = snapshot.data.docs[index].data();
                            var feedId = snapshot.data.docs[index].id;

                            return DriverFeed(
                                feedData: feedData, feedId: feedId);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: ButtonTheme(
                        minWidth: 60.0,
                        height: 60.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateTrip(feedType: 'rideRequest')));
                          },
                          child: Icon(
                            FontAwesomeIcons.plus,
                            size: 16.0,
                            color: Color(0xFFFFFFFF),
                          ),
                          color: vinkRed,
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(color: vinkRed),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
