import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_moment/simple_moment.dart';

final defaultPic =
    'https://aed.cals.arizona.edu/sites/aed.cals.arizona.edu/files/images/people/default-profile_1.png';
final vinkLightGrey = Color(0xfff2f2f2);
final vinkRed = Color(0xffcc1719);

String dateTime(Timestamp timestamp) {
  var dateTime =
      new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  Moment rawDate = Moment.parse(dateTime.toString());
  return rawDate.format("MMM, dd yyyy");
}

String dateWithDash(Timestamp timestamp) {
  var dateTime =
      new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  Moment rawDate = Moment.parse(dateTime.toString());
  return rawDate.format("dd-MM-yy");
}

String dateInWords(Timestamp timestamp) {
  var dateTime =
      new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  Moment rawDate = Moment.parse(dateTime.toString());
  var difference = dateTime.difference(new DateTime.now()).inDays;
  switch (difference) {
    case 0:
      return 'Today';
      break;
    case -1:
      return 'Yesterday';
      break;
    default:
      return rawDate.format('MMM, dd yyyy');
      break;
  }
}

String hoursMinutes(Timestamp timestamp) {
  var dateTime =
      new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  Moment rawDate = Moment.parse(dateTime.toString());
  return rawDate.format("hh:mm");
}

String hoursMinutesInText(Timestamp timestamp) {
  var dateTime = timestamp.toDate();
  Moment rawDate = Moment.parse(dateTime.toString());
  var difference = dateTime.difference(new DateTime.now()).inDays;
  print(difference);
  switch (difference) {
    case 0:
      return rawDate.format("hh:mm");
      break;
    case -1:
      return 'Yesterday';
      break;
    default:
      return rawDate.format('dd/mm/yy');
      break;
  }
}

String timeAgo(Timestamp timestamp) {
  var dateTime =
      new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  Moment rawDate = Moment.parse(dateTime.toString());
  return rawDate.fromNow();
}

loading(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: Text("Loading..."),
          ));
}

errorPage(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: Text("Error occured.."),
          ));
}

InputDecoration formDecor(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hint,
    contentPadding: const EdgeInsets.all(15),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(0),
    ),
  );
}

InputDecoration searchBarDeco(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Color(0xFFE6E6E6),
    hintText: hint,
    contentPadding: const EdgeInsets.all(15),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE6E6E6)),
      borderRadius: BorderRadius.circular(50),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE6E6E6)),
      borderRadius: BorderRadius.circular(50),
    ),
  );
}

TextStyle formTextStyle() {
  return TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
}

TextStyle hairstyleTextStyle() {
  return TextStyle(
      fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600);
}

Widget splashScreen() {
  return Scaffold(
    appBar: AppBar(
      title: Text(""),
      backgroundColor: Color(0xFFFFFFF),
      elevation: 0.0,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/vink_icon.png',
                  width: 120.0,
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}

void fullImagePage(BuildContext context, String image) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (ctx) => Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: context,
              child: bigImage(context, image),
            ),
          ],
        ),
      ),
    ),
  ));
}

void fullImageMemory(BuildContext context, Uint8List image) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (ctx) => Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: context,
              child: Container(
                child: Image.memory(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ));
}

Widget bigImage(BuildContext context, String image) {
  return Flexible(
    child: Image.network(image),
  );
}

TextStyle clientRequestInfoTextStyle() {
  return TextStyle(
      fontSize: 15, color: Color(0xFFB3B3B3), fontWeight: FontWeight.w500);
}

bool isValidPhoneNumber(String number) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  return !regExp.hasMatch(number) ? false : true;
}

bool isValidAddress(String address) {
  List addressSegments = address.split(",");
  return addressSegments.length < 2 ? false : true;
}

bool isValidateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return !regex.hasMatch(value) ? false : true;
}

bool isValidUrl(String url) {
  Pattern pattern =
      r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
  RegExp regex = new RegExp(pattern);
  return !regex.hasMatch(url) ? false : true;
}
