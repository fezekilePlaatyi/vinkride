import 'package:Vinkdriver/constants.dart';
import 'package:Vinkdriver/model/ShareToOtherPlatforms.dart';
import 'package:Vinkdriver/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:Vinkdriver/model/DynamicLinks.dart';
import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/model/User.dart';
import 'package:Vinkdriver/routes/routes.gr.dart';
// import 'package:Vinkdriver/model/ShareToOtherPlatforms.dart';
// import 'package:Vinkdriver/services/DeviceLocation.dart';

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
                  'Driver',
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
            Routes.navigator.popAndPushNamed(Routes.chatHistory);
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
            Routes.navigator.popAndPushNamed(Routes.myFeeds);
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
            Routes.navigator.popAndPushNamed(
              Routes.profile,
              arguments: ProfileArguments(
                userId: Utils.AUTH_USER.uid,
                userType: UserType.DRIVER,
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
            Share share = new Share(context);
            share.shareText(Constants.VINK_SHARE_TEXT, '');
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
            Routes.navigator.popAndPushNamed(Routes.vinkDetails);
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
            _user.signOut();
          },
        ),
      ],
    );
  }
}
