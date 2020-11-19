import 'package:Vinkdriver/model/Feeds.dart';
import 'package:Vinkdriver/views/CreateTrip.dart';
import 'package:Vinkdriver/views/SearchRide.dart';
import 'package:Vinkdriver/widget/Menu.dart';
import 'package:Vinkdriver/widget/RideRequest.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Vinkdriver/model/Helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Feeds feeds = new Feeds();
  var feedType = 'rideRequest';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: SideMenu(),
        ),
        key: _scaffoldKey,
        backgroundColor: Color(0xFFFCF9F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCF9F9),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Ride Requests',
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
                        builder: (_) => SearchRide(typeOfRide: 'rideRequest')))
              },
              icon: Icon(
                Icons.search,
                size: 25,
                color: Color(0xFFCC1718),
              ),
            ),
            IconButton(
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
              icon: Icon(
                Icons.menu,
                size: 25,
                color: Color(0xFFCC1718),
              ),
            ),
          ],
        ),
        body: _DriverHome(feedType));
  }

  _DriverHome(String feedType) {
    return Container(
        child: Stack(children: [
      StreamBuilder(
          stream: feeds.getAllFeeds(feedType),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data.docs.length > 0) {
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
                              // return Text("Feed data $feedata");
                              return RideRequest(
                                  feedData: feedData, feedId: feedId);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                    alignment: Alignment(-0.9, -0.9),
                    child: Text(
                      "No request!",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ));
              }
            }
          }),
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
                      builder: (_) => CreateTrip(feedType: "rideOffer")));
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
    ]));
  }
}
