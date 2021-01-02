import 'package:flutter/material.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/widgets/userTrips.dart';

class MyFeeds extends StatefulWidget {
  @override
  MyFeedsState createState() => MyFeedsState();
}

class MyFeedsState extends State<MyFeeds> {
  String _tabItemName = TripConst.ACTIVE_TRIP;
  var title = 'My Feed';
  bool _isLoading = false;

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
          onPressed: () => Routes.navigator.pop(),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF1B1B1B),
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: TabBar(
                  indicatorColor: vinkBlack,
                  labelColor: vinkBlack,
                  unselectedLabelColor: vinkLightGrey,
                  onTap: (value) {
                    String tabItem = TripConst.ACTIVE_TRIP;
                    switch (value) {
                      case 0:
                        tabItem = TripConst.ACTIVE_TRIP;
                        break;
                      case 1:
                        tabItem = TripConst.ONCOMING_TRIP;
                        break;
                      case 2:
                        tabItem = TripConst.COMPLETED_TRIP;
                        break;

                      default:
                    }
                    setState(() {
                      _tabItemName = tabItem;
                      _isLoading = true;
                    });

                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "Active",
                        style: _tabTextStyle(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Oncoming",
                        style: _tabTextStyle(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Historic",
                        style: _tabTextStyle(),
                      ),
                    ),
                  ]),
            ),
            _isLoading ? _loader() : _widgetChanger(_tabItemName),
          ],
        ),
      ]),
    );
  }

  _widgetChanger(String tabItemName) {
    return UserTrips(feedStatus: tabItemName, parentContext: context);
  }

  Widget _loader() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  TextStyle _tabTextStyle() {
    return TextStyle(
      color: Color(0xFF1B1B1B),
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );
  }
}
