import 'package:flutter/material.dart';
import 'package:Vinkdriver/widget/negotiatePrice.dart';

class DialogHelper {
  static insertPrice(context, rideId, feedData, userIdPoking) => showDialog(
      context: context,
      builder: (_) {
        return NegotiatePrice(
            rideId: rideId, feedData: feedData, userIdPoking: userIdPoking);
      });
}
