import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/model/User.dart';
import 'package:Vinkdriver/routes/routes.gr.dart';
import 'package:Vinkdriver/views/animations/fadeAnimation.dart';
import 'package:flutter/material.dart';

class CarRegitration extends StatefulWidget {
  @override
  _CarRegitrationState createState() => _CarRegitrationState();
}

class _CarRegitrationState extends State<CarRegitration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _carName, _carModel, _carRegistrationNumber;
  User _user = new User();
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).viewPadding;
    return Padding(
      padding: devicePadding,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FadeAnimation(
                          1.2,
                          TextFormField(
                            style: textStyle(16, vinkBlack),
                            decoration: formDecor('Car Name'),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Car name is require';
                              }
                            },
                            onSaved: (input) => _carName = input,
                          ),
                        ),
                        FadeAnimation(
                          1.4,
                          TextFormField(
                            style: textStyle(16, vinkBlack),
                            decoration: formDecor('Car Model'),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Car model is required';
                              }
                            },
                            onSaved: (input) => _carModel = input,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        FadeAnimation(
                          1.6,
                          TextFormField(
                            style: textStyle(16, vinkBlack),
                            decoration: formDecor('Car Registration No.'),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Car Registration number is required';
                              }
                            },
                            onSaved: (input) => _carRegistrationNumber = input,
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
                              'Save and continue',
                              style: textStyle(16, Colors.white),
                            ),
                            textColor: Colors.white,
                            shape: darkButton(),
                            padding: const EdgeInsets.all(15),
                            onPressed: () {
                              _saveCar();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveCar() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _user
          .setCarRecord(
              carName: _carName,
              carModel: _carModel,
              carRegistrationNumber: _carRegistrationNumber)
          .then((value) {
        if (value as bool) {
          Routes.navigator.popAndPushNamed(Routes.profilePicture);
        }
      });
    }
  }
}
