import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/views/animations/fadeAnimation.dart';
import 'package:flutter/material.dart';

class CarRegitration extends StatefulWidget {
  @override
  _CarRegitrationState createState() => _CarRegitrationState();
}

class _CarRegitrationState extends State<CarRegitration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeAnimation(
                1,
                Image.asset(
                  'assets/images/logo.png',
                  height: 90,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              FadeAnimation(
                1.2,
                TextFormField(
                  style: textStyle(16, vinkBlack),
                  decoration: formDecor('Car Name'),
                ),
              ),
              FadeAnimation(
                1.4,
                TextFormField(
                  style: textStyle(16, vinkBlack),
                  decoration: formDecor('Car Model'),
                ),
              ),
              SizedBox(height: 10.0),
              FadeAnimation(
                1.6,
                TextFormField(
                  style: textStyle(16, vinkBlack),
                  decoration: formDecor('Car Registration No.'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(
                1.8,
                RaisedButton(
                  color: vinkBlack,
                  child: Text(
                    'Finish',
                    style: textStyle(16, Colors.white),
                  ),
                  textColor: Colors.white,
                  shape: darkButton(),
                  padding: const EdgeInsets.all(15),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
