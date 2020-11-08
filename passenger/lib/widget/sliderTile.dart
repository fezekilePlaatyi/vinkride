import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:passenger/model/Helper.dart';

class SliderTile extends StatelessWidget {
  String imageAssetsPath, title, description;
  SliderTile({this.imageAssetsPath, this.title, this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAssetsPath,
            width: 300.0,
          ),
          SizedBox(height: 20.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'roboto',
              color: vinkBlack,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'roboto',
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
