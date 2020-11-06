// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:passenger/widget/login.dart';
import 'package:passenger/views/passengerForm.dart';

class Routes {
  static const loginPage = '/';
  static const passengerForm = '/passenger-form';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Routes>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.loginPage:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      case Routes.passengerForm:
        return MaterialPageRoute(
          builder: (_) => PassengerForm(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
