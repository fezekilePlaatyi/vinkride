import 'package:flutter/material.dart';
import 'package:passenger/widget/passengerSingleFeed.dart';
import 'package:passenger/widget/toGoUpdate.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF9F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF9F9),
        elevation: 0,
        title: Text(
          'Inter-interests',
          style: TextStyle(
            color: Color(0xFF1B1B1B),
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.search,
              size: 25,
              color: Color(0xFFCC1718),
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.menu,
              size: 25,
              color: Color(0xFFCC1718),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: false,
                children: [
                  ToGoUpdate(),
                  SizedBox(height: 10.0),
                  PassengerSingleFeed(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
