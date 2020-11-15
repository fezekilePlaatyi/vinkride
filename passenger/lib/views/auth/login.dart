import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/utils/Utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  User _user = new User();

  Future<void> _login() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      await _user.signIn(_email, _password).then((value) async {
        setState(() {
          isLoading = false;
        });

        if (value as bool) {
          await _user.getUserForCheck().then((doc) {
            if (doc != null) {
              switch (doc['registration_progress'] as int) {
                case 40:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Routes.navigator.pushNamed(Routes.passengerForm);
                  });
                  break;
                case 80:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Routes.navigator.pushNamed(Routes.profilePicture);
                  });
                  break;
                case 100:
                  if (Utils.AUTH_USER.emailVerified) {
                    if (doc['is_user_approved'] as bool) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Routes.navigator.pushNamed(Routes.home);
                      });
                    } else {
                      errorFloatingFlushbar(
                          'Your account is still being reviewed.');
                      print('Your account is still being reviewed.');
                      return _loginForm();
                    }
                  } else {
                    errorFloatingFlushbar('Please verify your email address');
                    Utils.AUTH_USER.sendEmailVerification();
                    return _loginForm();
                  }
                  break;
                default:
                  errorFloatingFlushbar('No record found');
                  return _loginForm();
              }
            } else {
              errorFloatingFlushbar('No record found');
              return _loginForm();
            }
          });
        }
      }).catchError((err) {
        print(err);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      print('Validation Failed!');
    }
  }

  Widget _loginForm() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
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
                          TextFormField(
                            onSaved: (input) => _email = input,
                            validator: (input) {
                              return input.isEmpty
                                  ? "Email address is required"
                                  : null;
                            },
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: formDecor("Email Address"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onSaved: (input) => _password = input,
                            validator: (input) {
                              return input.length < 1
                                  ? "Password is required"
                                  : null;
                            },
                            obscureText: true,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: formDecor("Password"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                child: GestureDetector(
                                  // onTap: () => Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => ForgotPassword(),
                                  //   ),
                                  // ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'roboto',
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                textColor: vinkRed,
                                onPressed: () => {},
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            color: Colors.black87,
                            child: Text(
                              'Login',
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
                            onPressed: () => {_login()},
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: vinkBlack,
                                  fontFamily: 'roboto',
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              GestureDetector(
                                onTap: () {
                                  Routes.navigator.pushNamed(Routes.signUp);
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: vinkRed,
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
                  ],
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Utils.AUTH_USER != null
        ? StreamBuilder(
            stream: _user.loadCurrentUser(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {
              if (snap.hasData) {
                final doc = snap.data.data();
                if (doc != null) {
                  switch (doc['registration_progress'] as int) {
                    case 40:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Routes.navigator.pushNamed(Routes.passengerForm);
                      });
                      break;
                    case 80:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Routes.navigator.pushNamed(Routes.profilePicture);
                      });
                      break;
                    case 100:
                      if (Utils.AUTH_USER.emailVerified) {
                        if (doc['is_user_approved'] as bool) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Routes.navigator.pushNamed(Routes.home);
                          });
                        } else {
                          return _loginForm();
                        }
                      } else {
                        Utils.AUTH_USER.sendEmailVerification();
                        return _loginForm();
                      }
                      break;
                    default:
                      return _loginForm();
                  }
                } else {
                  return _loginForm();
                }
              }
              return splashScreen();
            },
          )
        : _loginForm();
  }
}
