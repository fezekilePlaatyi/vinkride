import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passenger/model/onboardingModel.dart';
import 'package:passenger/model/Helper.dart';
import 'package:passenger/model/User.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/utils/Utils.dart';
import 'package:passenger/widget/sliderTile.dart';

class OnboardingSlider extends StatefulWidget {
  @override
  _OnboardingSliderState createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  List<OnboardingModel> slides = new List<OnboardingModel>();
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  User _user = new User();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides = getSlides();
  }

  Widget pageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 8.0 : 7.0,
      width: isCurrentPage ? 25.0 : 7.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? vinkBlack : Color(0xFFeE6E6E6),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (Utils.AUTH_USER != null) {
            return StreamBuilder(
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
                              Routes.navigator.popAndPushNamed(Routes.home);
                            });
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Routes.navigator
                                  .popAndPushNamed(Routes.loginPage);
                            });
                          }
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Routes.navigator.popAndPushNamed(Routes.loginPage);
                          });
                        }
                        break;
                      default:
                        return _slider();
                    }
                  } else {
                    return _slider();
                  }
                }
                return splashScreen();
              },
            );
          } else {
            return _slider();
          }
        } else {
          return splashScreen();
        }
      },
    );
  }

  Widget _checkUser() {
    return FutureBuilder(
      future: _user.isLoggedIn(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
        if (snap.connectionState == ConnectionState.done) {
          bool userExists = snap.data != null ? snap.data.exists : false;
          if (userExists) {
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
                    Routes.navigator.pushNamed(Routes.loginPage);
                  }
                } else {
                  errorFloatingFlushbar('Please verify your email address');
                  Routes.navigator.pushNamed(Routes.loginPage);
                }
                break;
              default:
                Routes.navigator.pushNamed(Routes.loginPage);
                break;
            }
            return splashScreen();
          } else {
            Routes.navigator.pushNamed(Routes.loginPage);
          }
        }
        return splashScreen();
      },
    );
  }

  Widget _slider() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: pageController,
        itemCount: slides.length,
        onPageChanged: (val) {
          setState(() {
            currentIndex = val;
          });
        },
        itemBuilder: (context, index) {
          return SliderTile(
            imageAssetsPath: slides[index].getImageAssetsPath(),
            title: slides[index].getTitle(),
            description: slides[index].getDescription(),
          );
        },
      ),
      bottomSheet: currentIndex != slides.length - 1
          ? Container(
              color: Colors.white,
              height: Platform.isIOS ? 70.0 : 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: () {
                      pageController.animateToPage(
                        slides.length - 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    },
                    child: Text('SKIP'),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < slides.length; i++)
                        currentIndex == i
                            ? pageIndicator(true)
                            : pageIndicator(false)
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      pageController.animateToPage(
                        currentIndex + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    },
                    child: Text('NEXT'),
                  ),
                ],
              ),
            )
          : Container(
              height: Platform.isIOS ? 70.0 : 60.0,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              color: vinkBlack,
              child: FlatButton(
                onPressed: () {
                  Routes.navigator.pushNamed(Routes.loginPage);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
    );
  }
}
