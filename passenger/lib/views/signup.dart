import 'package:flutter/material.dart';
import 'package:passenger/main.dart';
import 'package:passenger/model/Helper.dart';
import 'package:passenger/model/User.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/views/passengerForm.dart';

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
          print('TEST VALUE  $value');
          if (value as bool) {
            Routes.navigator.pushReplacementNamed(Routes.passengerForm);
          }
        }).catchError((err) {
          print('TEST VALUE  $err');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                    Image.asset(
                      'assets/images/logo.png',
                      height: 90,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
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
                              } else if (input.split(' ').length < 2) {
                                return 'Provide a full name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                          SizedBox(
                            height: 10,
                          ),
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
                            onSaved: (input) => _confirm_passwod = input,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Password is required';
                              } else if (input.length < 6) {
                                return 'Password should be at least 6 characters';
                              }
                              return null;
                            },
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
                      onPressed: () {
                        _signup();
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Color(0xFF1B1B1B),
                            fontFamily: 'roboto',
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(width: 5.0),
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
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
