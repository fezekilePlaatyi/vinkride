// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:Vinkdriver/views/onboarding.dart';
import 'package:Vinkdriver/views/login.dart';
import 'package:Vinkdriver/views/driverForm.dart';
import 'package:Vinkdriver/views/Home.dart';
import 'package:Vinkdriver/views/signup.dart';
import 'package:Vinkdriver/views/profilePicture.dart';

class Routes {
  static const onboardingSlider = '/';
  static const loginPage = '/login-page';
  static const driverForm = '/driver-form';
  static const home = '/home';
  static const signUp = '/sign-up';
  static const profilePicture = '/profile-picture';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Routes>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.onboardingSlider:
        return MaterialPageRoute(
          builder: (_) => OnboardingSlider(),
          settings: settings,
        );
      case Routes.loginPage:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      case Routes.driverForm:
        return MaterialPageRoute(
          builder: (_) => DriverForm(),
          settings: settings,
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => Home(),
          settings: settings,
        );
      case Routes.signUp:
        return MaterialPageRoute(
          builder: (_) => SignUP(),
          settings: settings,
        );
      case Routes.profilePicture:
        return MaterialPageRoute(
          builder: (_) => ProfilePicture(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
