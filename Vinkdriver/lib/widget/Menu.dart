import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vinkdriver/Constants.dart';
import 'package:Vinkdriver/helper/Helper.dart';
import 'package:Vinkdriver/model/ShareToOtherPlatforms.dart';
import 'package:Vinkdriver/model/User.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenu extends StatefulWidget {
  SideMenu();
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  var _userInfo = new User();
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
      stream: _userInfo.loadCurrentUser(),
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
                  user["isDriver"] as bool ? 'Driver' : 'Passenger',
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
            // Navigator.of(context).pop();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => NotificationsDisplay(),
            //   ),
            // );
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
            // Navigator.of(context).pop();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => ChatHistory(),
            //   ),
            // );
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
            // Navigator.of(context).pop();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => MyFeeds(),
            //   ),
            // );
          },
        ),
        ListTile(
          title: Text(
            'Profile',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          leading: Icon(
            FontAwesomeIcons.creditCard,
            color: Color(0xFFCC1719),
          ),
          onTap: () {
            // Navigator.of(context).pop();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => Profile(),
            //   ),
            // );
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
            Share share = new Share(context);
            share.shareText(
                '${Constants.VINK_SHARE_TEXT} https://play.google.com/store?gl=ZA',
                '');
          },
        ),
        ListTile(
          title: Text(
            'Contact Vink',
            style: TextStyle(color: Color(0xFF1B1B1B)),
          ),
          leading: Icon(
            FontAwesomeIcons.userAlt,
            color: Color(0xFFCC1719),
          ),
          onTap: () {
            // Navigator.of(context).pop();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => VinkDetails(),
            //   ),
            // );
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
            _userInfo.signOut();
          },
        ),
      ],
    );
  }
}
