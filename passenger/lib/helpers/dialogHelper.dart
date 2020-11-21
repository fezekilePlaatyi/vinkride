import 'package:flutter/material.dart';
import 'package:passenger/widgets/negotiatePrice.dart';

class DialogHelper {
  static insertPrice(context, rideId, feedData) => showDialog(
      context: context,
      builder: (_) {
        return NegotiatePrice(rideId: rideId, feedData: feedData);
      });

  static loadingDialogWithMessage(context, isLoading, message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          subtitle: isLoading
              ? Container(
                  height: 50.0,
                  width: 50.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Text(message),
        ),
        actions: <Widget>[
          isLoading
              ? SizedBox.shrink()
              : FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Got it!"),
                )
        ],
      ),
    );
  }
}
