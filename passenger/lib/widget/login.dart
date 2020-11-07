import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passenger/model/Helper.dart';
import 'package:passenger/model/User.dart';
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
      _user.signIn(_email, _password).then((value) {
        setState(() {
          isLoading = false;
        });
        if (value as bool) {
          Routes.navigator.pushReplacementNamed(Routes.home);
        }
      }).catchError((err) {
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
                            height: 100,
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
                                      fontSize: 16,
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
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              FlatButton(
                                child: GestureDetector(
                                  child: Text(
                                    'Sign Up',
                                    style:
                                        TextStyle(color: vinkRed, fontSize: 16),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                onPressed: () {
                                  Routes.navigator.pushNamed(Routes.signUp);
                                },
                              )
                            ],
                          )
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
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: _user.isLoggedIn(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (snap.data.exists) {
                  final doc = snap.data.data();
                  switch (doc['registration_progress'] as int) {
                    case 40:
                      Routes.navigator.pushNamed(Routes.passengerForm);
                      break;
                    case 80:
                      Routes.navigator.pushNamed(Routes.profilePicture);
                      break;
                    case 100:
                      if (Utils.AUTH_USER.emailVerified) {
                        if (doc['is_user_approved'] as bool) {
                          Routes.navigator.pushNamed(Routes.home);
                        } else {
                          errorFloatingFlushbar(
                              'Your account is still being reviewed.');
                          return _loginForm();
                        }
                      } else {
                        errorFloatingFlushbar(
                            'Please verify your email address');
                        return _loginForm();
                      }
                      break;
                    default:
                      return _loginForm();
                      break;
                  }
                  return splashScreen();
                } else {
                  return _loginForm();
                }
              }
              return splashScreen();
            },
          );
        }
        return splashScreen();
      },
    );
  }
}
