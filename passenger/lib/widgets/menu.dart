import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passenger/models/DynamicLinks.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart';
// import 'package:passenger/model/ShareToOtherPlatforms.dart';
// import 'package:passenger/model/User.dart';
// import 'package:passenger/services/DeviceLocation.dart';
import 'package:passenger/views/chat/ChatHistory.dart';
// import 'package:passenger/views/myFeeds.dart';
// import 'package:passenger/views/notificationsDisplay.dart';
// import 'package:passenger/views/profile.dart';
// import 'package:passenger/views/vinkDetails.dart';
// import 'package:passenger/widgets/userTrips.dart';

class SideMenu extends StatefulWidget {
  SideMenu();
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  User _user = new User();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[_drawerHeader(), _menuItems()],
      ),
    );
  }

  _drawerHeader() {
    return StreamBuilder(
      stream: _user.loadCurrentUser(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map user = snapshot.data.data();
          return DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: user.containsKey('profile_pic')
                          ? Image.network(user['profile_pic'],
                              fit: BoxFit.fitWidth)
                          : Image.network(
                              defaultPic,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  user["name"].toString(),
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Passenger',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFFF2F2F2),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFFCC1719),
            ),
          );
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  _menuItems() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Home',
            style: TextStyle(
              color: Color(0xFF1B1B1B),
            ),
          ),
          leading: Icon(
            FontAwesomeIcons.home,
            color: Color(0xFFCC1719),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.solidBell,
            color: Color(0xFFCC1719),
          ),
          title: Text(
            'Notifications',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => null,
                // NotificationsDisplay(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.solidComments,
            color: Color(0xFFCC1719),
          ),
          title: Text(
            'Chat',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatHistory(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            'My Rides',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          leading: Icon(
            FontAwesomeIcons.briefcase,
            color: Color(0xFFCC1719),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => null,
                // MyFeeds(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            'Profile',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          leading: Icon(
            FontAwesomeIcons.userAlt,
            color: Color(0xFFCC1719),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => null,
                // Profile(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.share,
            color: Color(0xFFCC1719),
          ),
          title: Text(
            'Share Vink to other apps',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          onTap: () {
            Navigator.of(context).pop();
            // Share share = new Share(context);
            // share.shareText(
            //     '${Constants.VINK_SHARE_TEXT} https://play.google.com/store?gl=ZA',
            //     '');
          },
        ),
        ListTile(
          title: Text(
            'Contact Vink',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          leading: Icon(
            FontAwesomeIcons.phoneAlt,
            color: Color(0xFFCC1719),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => null,
                // VinkDetails(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            'Logout',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          leading: Icon(
            FontAwesomeIcons.signOutAlt,
            color: Color(0xFFCC1719),
          ),
          onTap: () {
            // _userInfo.logOut(context);
          },
        ),
      ],
    );
  }
}
