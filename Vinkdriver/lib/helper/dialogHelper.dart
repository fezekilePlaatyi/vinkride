import 'package:flutter/material.dart';
import 'package:Vinkdriver/widget/negotiatePrice.dart';

class DialogHelper {
  static insertPrice(context, rideId, userIdPoking) => showDialog(
      context: context,
      builder: (context) =>
          NegotiatePrice(rideId: rideId, userId: userIdPoking));
  // static rating(context) => showDialog(
  //     context: context, buil der: (context) => RatingServiceProvider());

  // static passengers(context) =>
  //     showDialog(context: context, builder: (context) => RidingWith());
}
