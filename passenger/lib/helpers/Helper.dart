import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:passenger/models/Helper.dart';
import 'package:simple_moment/simple_moment.dart';

final defaultPic =
    'https://aed.cals.arizona.edu/sites/aed.cals.arizona.edu/files/images/people/default-profile_1.png';
final userRef = FirebaseFirestore.instance.collection("users");
final chatRef = FirebaseFirestore.instance.collection("chats");
final requestRef = FirebaseFirestore.instance.collection("requests");
final vinkCategoryRef =
    FirebaseFirestore.instance.collection("vink_categories");

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

void errorFloatingFlushbar(BuildContext context, String message) {
  Flushbar(
    duration: Duration(seconds: 2),
    padding: EdgeInsets.all(10),
    borderRadius: 8,
    backgroundGradient: LinearGradient(
      colors: [
        vinkRed,
        Colors.redAccent.shade200,
      ],
      stops: [0.7, 1],
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    // All of the previous Flushbars could be dismissed by swiping down
    // now we want to swipe to the sides
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    // The default curve is Curves.easeOut
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: 'error occured',
    message: message,
    isDismissible: true,
    margin: EdgeInsets.symmetric(
      horizontal: 5.0,
      vertical: 15.0,
    ),
    icon: Icon(
      Icons.close,
      color: Colors.white,
    ),
  ).show(context);
}

void successFloatingFlushbar(BuildContext context, String message) {
  Flushbar(
    duration: Duration(seconds: 2),
    padding: EdgeInsets.all(10),
    borderRadius: 8,
    backgroundGradient: LinearGradient(
      colors: [
        Colors.green[900],
        Colors.greenAccent[700],
      ],
      stops: [0.6, 1],
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    // All of the previous Flushbars could be dismissed by swiping down
    // now we want to swipe to the sides
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    // The default curve is Curves.easeOut
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: 'Success',
    message: message,
    isDismissible: true,
    margin: EdgeInsets.symmetric(
      horizontal: 5.0,
      vertical: 15.0,
    ),
    icon: Icon(
      Icons.check,
      color: Colors.white,
    ),
  ).show(context);
}

errorPage(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: Text("Error occured.."),
          ));
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

alertDialogOnNoCardAdded(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: ListTile(
        subtitle: Text("Problem occured while trying to get card details!"),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text("Add Card"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    ),
  );
}
