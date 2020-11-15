import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static _launchCaller(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static formatDateIntoDDMMYY(firebaseServerDateTime) {
    return DateFormat('dd-MM-yy').format(firebaseServerDateTime.toDate());
  }

  static getTimeFromFirebaseTimestamp(firebaseServerDateTime) {
    return DateFormat('kk:mm').format(firebaseServerDateTime.toDate());
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    // ignore: deprecated_member_use
    File selectedImage = await ImagePicker.pickImage(source: source);
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(1000);

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());

    return new File('$path/img_$random.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 90));
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Note"),
          content: Text("Now we are about to do deduction on card"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {},
            )
          ],
        );
      },
    );
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static showAlert(context, title, subtitle, buttonText) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(buttonText),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
  }
}
