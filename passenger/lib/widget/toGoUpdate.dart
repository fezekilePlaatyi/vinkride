import 'package:flutter/material.dart';
import 'package:passenger/model/Helper.dart';

class ToGoUpdate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color(0xFFCC1718),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            offset: Offset.zero,
            blurRadius: 4,
            spreadRadius: 0.2,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            Color(0xFF1B1B1B),
            Color(0xFFCC1718),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'You have a trip',
            style: textStyle(20, Colors.white),
          ),
          Text('Leaving in 3 days', style: textStyle(30, Colors.white)),
          SizedBox(
            height: 10.0,
          ),
          FlatButton(
            onPressed: null,
            child: Text(
              'More Details',
              style: textStyle(16, Colors.white),
            ),
            shape: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.circular(50),
            ),
          )
        ],
      ),
    );
  }
}
