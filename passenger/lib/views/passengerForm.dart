import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger/models/Helper.dart';

class PassengerForm extends StatefulWidget {
  @override
  _PassengerFormState createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                height: 70,
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Add Your Contact Details",
                  style: TextStyle(
                    color: Color(0xFF1B1B1B),
                    fontFamily: 'Roboto',
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    style: formTextStyle(),
                    autocorrect: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: formDecor('Contact Number'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: formTextStyle(),
                    decoration: formDecor("Address"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
              RaisedButton(
                color: Colors.black87,
                child: GestureDetector(
                  child: Text(
                    'Save and continue',
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                textColor: Colors.white,
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(15),
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
