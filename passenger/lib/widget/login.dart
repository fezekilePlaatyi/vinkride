import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passenger/model/Helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                            onPressed: () => {},
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
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => SignUP(),
                                  //   ),
                                  // );
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

  Widget _splash() {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/images/vink_icon.png',
            height: 50.0,
            width: 50.0,
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
          return _loginForm();
        }
        return _splash();
      },
    );
  }
}
