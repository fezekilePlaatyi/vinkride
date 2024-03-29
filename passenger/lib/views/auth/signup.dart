import 'package:flutter/material.dart';
import 'package:passenger/animations/fadeAnimation.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/routes/routes.gr.dart';

class SignUP extends StatefulWidget {
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  String _name, _email, _password, _confirm_passwod;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  User _user = new User();
  _signup() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_password == _confirm_passwod) {
        setState(() {
          isLoading = true;
        });

        _user.signUp(_name, _email, _password).then((value) {
          setState(() {
            isLoading = false;
          });
          if (value as bool) {
            Routes.navigator.popAndPushNamed(Routes.passengerForm);
          }
        }).catchError((err) {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        errorFloatingFlushbar('Password does not match');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).viewPadding;
    return Padding(
      padding: devicePadding,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center(
                child: SingleChildScrollView(
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
                            FadeAnimation(
                              1,
                              Image.asset(
                                'assets/images/logo.png',
                                height: 90,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  FadeAnimation(
                                    1.2,
                                    TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      decoration: formDecor("Full Name"),
                                      onSaved: (input) => _name = input,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Full name is required';
                                        } else if (input.length < 4) {
                                          return 'Full name is invalid';
                                        } else if (input.split(' ').length <
                                            2) {
                                          return 'Provide a full name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FadeAnimation(
                                    1.4,
                                    TextFormField(
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      decoration: formDecor("Email"),
                                      onSaved: (input) => _email = input,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Email is required';
                                        } else if (!isValidEmail(input)) {
                                          return 'Email is invalid';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FadeAnimation(
                                    1.6,
                                    TextFormField(
                                      obscureText: true,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      decoration: formDecor("Password"),
                                      onSaved: (input) => _password = input,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Password is required';
                                        } else if (input.length < 6) {
                                          return 'Password should be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FadeAnimation(
                                    1.8,
                                    TextFormField(
                                      obscureText: true,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      decoration: formDecor("Confirm Password"),
                                      onSaved: (input) =>
                                          _confirm_passwod = input,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Password is required';
                                        } else if (input.length < 6) {
                                          return 'Password should be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            FadeAnimation(
                              2,
                              RaisedButton(
                                color: vinkBlack,
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                                textColor: Colors.white,
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.all(15),
                                onPressed: () {
                                  _signup();
                                },
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FadeAnimation(
                                  2.2,
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Color(0xFF1B1B1B),
                                      fontFamily: 'roboto',
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                FadeAnimation(
                                  2.4,
                                  GestureDetector(
                                    onTap: () {
                                      Routes.navigator.pop();
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Color(0xFFCC1718),
                                        fontFamily: 'roboto',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}
