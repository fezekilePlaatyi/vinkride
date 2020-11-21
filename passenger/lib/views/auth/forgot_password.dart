import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger/animations/fadeAnimation.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/routes/routes.gr.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  User _user = new User();

  sendResetEmail() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      await _user.resetPassword(email).then((value) async {
        setState(() {
          isLoading = false;
        });
        if (value) {
          print('before 2 seconds');
          await Future.delayed(Duration(seconds: 2));
          Routes.navigator.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
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
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FadeAnimation(
                              1.4,
                              TextFormField(
                                validator: (val) {
                                  return isValidEmail(val)
                                      ? null
                                      : "Enter a correct email";
                                },
                                onSaved: (input) => email = input,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: formDecor("Email Address"),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                              1.7,
                              RaisedButton(
                                color: Colors.black87,
                                child: Text(
                                  'Reset password',
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
                                onPressed: () => sendResetEmail(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ));
  }
}
