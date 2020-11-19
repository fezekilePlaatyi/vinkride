import 'package:flutter/material.dart';
import 'package:passenger/widgets/negotiatePrice.dart';

class DialogHelper {
  static insertPrice(context, rideId, feedData) => showDialog(
      context: context,
      builder: (_) {
        return NegotiatePrice(rideId: rideId, feedData: feedData);
      });
}
