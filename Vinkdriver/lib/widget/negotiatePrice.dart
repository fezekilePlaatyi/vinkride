import 'package:flutter/material.dart';
import 'package:Vinkdriver/helper/helper.dart';

class NegotiatePrice extends StatefulWidget {
  final rideId, userId;
  NegotiatePrice({this.rideId, this.userId});
  @override
  _NegotiatePriceState createState() => _NegotiatePriceState();
}

class _NegotiatePriceState extends State<NegotiatePrice> {
  var amountAdjust = false;

  @override
  void initState() {
    super.initState();
    amountAdjust = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildNegotiationDialog(context),
    );
  }

  _buildNegotiationDialog(BuildContext context) => Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "About To Poke User.",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.0),
            FlatButton(
              child: Text(
                "Adjust money?",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              onPressed: () {
                setState(() {
                  amountAdjust = true;
                });
              },
            ),
            amountAdjust
                ? TextFormField(
                    decoration: formDecor("Enter units in ZARs"),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )
                : '',
            SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 10.0),
                RaisedButton(
                  onPressed: () {
                    print("hey");
                  },
                  child: Text('Submit'),
                  textColor: Colors.white,
                  color: Color(0xFF1B1B1B),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1B1B1B)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(10),
                )
              ],
            )
          ],
        ),
      );
}
