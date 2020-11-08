import 'package:flutter/material.dart';
import 'package:passenger/model/User.dart';

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  User _user = new User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Profile Pic'),
        ),
      ),
    );
  }
}
