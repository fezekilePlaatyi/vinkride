import 'package:flutter/material.dart';
import 'package:passenger/models/helper.dart';

class SingleNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0.4,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: CircleAvatar(
                  radius: 20,
                  child: ClipOval(
                    child: Image.network(
                      defaultPic,
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
                title: Text(
                  'Requested to join your trip',
                  style: TextStyle(
                    color: vinkBlack,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  'Simamkele Ndabeni requested to join your trip Mthatha to Durban at 22-11-20 22:20',
                  style: TextStyle(
                    color: vinkDarkGrey,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: null,
                    child: Text(
                      'View Profile',
                      style: textStyle(16, vinkRed),
                    ),
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(color: vinkRed),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  RaisedButton(
                    onPressed: () => {},
                    color: vinkBlack,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Text("Accept", style: textStyle(16, Colors.white)),
                    shape: darkButton(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
