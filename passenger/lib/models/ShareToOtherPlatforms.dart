import 'package:flutter/material.dart';
import 'package:share/share.dart' as shareToOtherPlatforms;

class Share {
  RenderBox box;

  Share(context) {
    box = context.findRenderObject();
  }

  shareWithFile(List<String> imagePaths, String text, String subject) async {
    await shareToOtherPlatforms.Share.shareFiles(imagePaths,
        text: text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  shareText(String text, String subject) async {
    await shareToOtherPlatforms.Share.share(text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
