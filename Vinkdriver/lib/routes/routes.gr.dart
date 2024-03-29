// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'dart:io';

import 'package:Vinkdriver/views/Notifications.dart';
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
import 'package:Vinkdriver/views/PokeUserOnTrip.dart';
import 'package:Vinkdriver/views/DriverFeed.dart';
import 'package:Vinkdriver/views/VinkDetails.dart';
import 'package:Vinkdriver/widget/negotiatePrice.dart';
import 'package:Vinkdriver/views/SearchRide.dart';
import 'package:Vinkdriver/views/CreateTrip.dart';
import 'package:Vinkdriver/views/auth/carRegistration.dart';
import 'package:Vinkdriver/views/user/myFeeds.dart';
import 'package:Vinkdriver/views/auth/forgot_password.dart';
import 'package:Vinkdriver/views/user/Profile.dart';

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
  static const pokeUserOnTrip = '/poke-user-on-trip';
  static const driverFeed = '/driver-feed';
  static const vinkDetails = '/vink-details';
  static const negotiatePrice = '/negotiate-price';
  static const searchRide = '/search-ride';
  static const createTrip = '/create-trip';
  static const carRegistration = '/car-registration';
  static const myFeeds = '/my-feeds';
  static const forgotPassword = '/forgot-password';
  static const profile = '/profile';
  static const notifications = '/notifications';
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
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => Notifications(),
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
      case Routes.pokeUserOnTrip:
        if (hasInvalidArgs<String>(args)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as Map;
        return MaterialPageRoute(
          builder: (_) => PokeUserOnTrip(feedData: typedArgs),
          settings: settings,
        );
      case Routes.driverFeed:
        if (hasInvalidArgs<DriverFeedArguments>(args)) {
          return misTypedArgsRoute<DriverFeedArguments>(args);
        }
        final typedArgs = args as DriverFeedArguments ?? DriverFeedArguments();
        return MaterialPageRoute(
          builder: (_) => DriverFeed(
              feedData: typedArgs.feedData, feedId: typedArgs.feedId),
          settings: settings,
        );
      case Routes.vinkDetails:
        return MaterialPageRoute(
          builder: (_) => VinkDetails(),
          settings: settings,
        );
      case Routes.negotiatePrice:
        if (hasInvalidArgs<NegotiatePriceArguments>(args)) {
          return misTypedArgsRoute<NegotiatePriceArguments>(args);
        }
        final typedArgs =
            args as NegotiatePriceArguments ?? NegotiatePriceArguments();
        return MaterialPageRoute(
          builder: (_) => NegotiatePrice(
              rideId: typedArgs.rideId,
              feedData: typedArgs.feedData,
              userIdPoking: typedArgs.userIdPoking),
          settings: settings,
        );
      case Routes.searchRide:
        if (hasInvalidArgs<String>(args)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute(
          builder: (_) => SearchRide(typeOfRide: typedArgs),
          settings: settings,
        );
      case Routes.createTrip:
        return MaterialPageRoute(
          builder: (_) => CreateTrip(),
          settings: settings,
        );
      case Routes.carRegistration:
        return MaterialPageRoute(
          builder: (_) => CarRegitration(),
          settings: settings,
        );
      case Routes.myFeeds:
        return MaterialPageRoute(
          builder: (_) => MyFeeds(),
          settings: settings,
        );
      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => ForgotPassword(),
          settings: settings,
        );
      case Routes.profile:
        if (hasInvalidArgs<ProfileArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<ProfileArguments>(args);
        }
        final typedArgs = args as ProfileArguments;
        return MaterialPageRoute(
          builder: (_) =>
              Profile(userId: typedArgs.userId, userType: typedArgs.userType),
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

//DriverFeed arguments holder class
class DriverFeedArguments {
  final Map<dynamic, dynamic> feedData;
  final String feedId;
  DriverFeedArguments({this.feedData, this.feedId});
}

//NegotiatePrice arguments holder class
class NegotiatePriceArguments {
  final String rideId;
  final Map<dynamic, dynamic> feedData;
  final String userIdPoking;
  NegotiatePriceArguments({this.rideId, this.feedData, this.userIdPoking});
}

//Profile arguments holder class
class ProfileArguments {
  final String userId;
  final String userType;
  ProfileArguments({@required this.userId, @required this.userType});
}
