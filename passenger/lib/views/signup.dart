import 'package:flutter/material.dart';
import 'package:passenger/main.dart';
import 'package:passenger/model/Helper.dart';
import 'package:passenger/views/passengerForm.dart';

class SignUP extends StatefulWidget {
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(shrinkWrap: true, children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: formDecor("Full Name")),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: formDecor("Email")),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            obscureText: true,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: formDecor("Password")),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: formDecor("Confirm Password"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    color: Colors.black87,
                    child: GestureDetector(
                      child: Text(
                        'Register',
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
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PassengerForm(),
                        ),
                      ),
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Have an account?",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Login',
                          style: TextStyle(color: vinkRed, fontSize: 16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        onPressed: () => {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => MyApp()))
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
