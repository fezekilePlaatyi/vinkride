import 'package:flutter/material.dart';
import 'package:passenger/widgets/negotiatePrice.dart';

class DialogHelper {
  static insertPrice(
          context, rideId, userIdPoking, amountWillingToPay, feedData) =>
      showDialog(
          context: context,
          builder: (_) {
            return NegotiatePrice(
                rideId: rideId,
                userId: userIdPoking,
                amountWillingToPay: amountWillingToPay,
                feedData: feedData);
          });
  // static rating(context) => showDialog(
  //     context: context, buil der: (context) => RatingServiceProvider());

  // static passengers(context) =>
  //     showDialog(context: context, builder: (context) => RidingWith());
}
