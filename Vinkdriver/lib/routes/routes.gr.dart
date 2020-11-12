// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:Vinkdriver/views/onboarding.dart';
import 'package:Vinkdriver/views/auth/login.dart';
import 'package:Vinkdriver/views/auth/driverForm.dart';
import 'package:Vinkdriver/views/Home.dart';
import 'package:Vinkdriver/views/auth/signup.dart';
import 'package:Vinkdriver/views/auth/profilePicture.dart';
import 'package:Vinkdriver/views/chat/ChatHistory.dart';
import 'package:Vinkdriver/views/chat/ChatMessage.dart';
import 'package:Vinkdriver/views/chat/previewAttachment.dart';

class Routes {
  static const onboardingSlider = '/';
  static const loginPage = '/login-page';
  static const driverForm = '/driver-form';
  static const home = '/home';
  static const signUp = '/sign-up';
  static const profilePicture = '/profile-picture';
  static const chatHistory = '/chat-history';
  static const chatMessage = '/chat-message';
  static const previewAttachment = '/preview-attachment';
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
      case Routes.chatHistory:
        return MaterialPageRoute(
          builder: (_) => ChatHistory(),
          settings: settings,
        );
      case Routes.chatMessage:
        if (hasInvalidArgs<String>(args, isRequired: true)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute(
          builder: (_) => ChatMessage(userId: typedArgs),
          settings: settings,
        );
      case Routes.previewAttachment:
        if (hasInvalidArgs<PreviewAttachmentArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<PreviewAttachmentArguments>(args);
        }
        final typedArgs = args as PreviewAttachmentArguments;
        return MaterialPageRoute(
          builder: (_) => PreviewAttachment(
              userId: typedArgs.userId,
              image: typedArgs.image,
              message: typedArgs.message),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//PreviewAttachment arguments holder class
class PreviewAttachmentArguments {
  final String userId;
  final File image;
  final String message;
  PreviewAttachmentArguments(
      {@required this.userId, @required this.image, @required this.message});
}
