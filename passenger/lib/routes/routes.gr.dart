// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:passenger/views/onboarding.dart';
import 'package:passenger/views/auth/login.dart';
import 'package:passenger/views/auth/passengerForm.dart';
import 'package:passenger/views/Home.dart';
import 'package:passenger/views/auth/signup.dart';
import 'package:passenger/views/auth/profilePicture.dart';
import 'package:passenger/views/chat/ChatHistory.dart';
import 'package:passenger/views/chat/ChatMessage.dart';
import 'package:passenger/views/chat/previewAttachment.dart';
import 'package:passenger/views/ViewingTrip.dart';
import 'package:passenger/views/user/myFeeds.dart';
import 'package:passenger/views/VinkDetails.dart';
import 'package:passenger/views/CreateTrip.dart';
import 'package:passenger/views/SearchRide.dart';
import 'package:passenger/widgets/RideRequest.dart';
import 'package:passenger/widgets/JoinTrip.dart';

class Routes {
  static const onboardingSlider = '/';
  static const loginPage = '/login-page';
  static const passengerForm = '/passenger-form';
  static const home = '/home';
  static const signUp = '/sign-up';
  static const profilePicture = '/profile-picture';
  static const chatHistory = '/chat-history';
  static const chatMessage = '/chat-message';
  static const previewAttachment = '/preview-attachment';
  static const viewingTrip = '/viewing-trip';
  static const myFeeds = '/my-feeds';
  static const vinkDetails = '/vink-details';
  static const createTrip = '/create-trip';
  static const searchRide = '/search-ride';
  static const rideRequest = '/ride-request';
  static const joinTrip = '/join-trip';
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
      case Routes.passengerForm:
        return MaterialPageRoute(
          builder: (_) => PassengerForm(),
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
      case Routes.viewingTrip:
        if (hasInvalidArgs<String>(args, isRequired: true)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute(
          builder: (_) => ViewingTrip(tripId: typedArgs),
          settings: settings,
        );
      case Routes.myFeeds:
        return MaterialPageRoute(
          builder: (_) => MyFeeds(),
          settings: settings,
        );
      case Routes.vinkDetails:
        return MaterialPageRoute(
          builder: (_) => VinkDetails(),
          settings: settings,
        );
      case Routes.createTrip:
        if (hasInvalidArgs<String>(args, isRequired: true)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute(
          builder: (_) => CreateTrip(feedType: typedArgs),
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
      case Routes.rideRequest:
        if (hasInvalidArgs<RideRequestArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<RideRequestArguments>(args);
        }
        final typedArgs = args as RideRequestArguments;
        return MaterialPageRoute(
          builder: (_) => RideRequest(
              feedData: typedArgs.feedData, feedId: typedArgs.feedId),
          settings: settings,
        );
      case Routes.joinTrip:
        if (hasInvalidArgs<JoinTripArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<JoinTripArguments>(args);
        }
        final typedArgs = args as JoinTripArguments;
        return MaterialPageRoute(
          builder: (_) => JoinTrip(
              tripId: typedArgs.tripId,
              driverId: typedArgs.driverId,
              tripData: typedArgs.tripData,
              paymentToken: typedArgs.paymentToken),
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

//RideRequest arguments holder class
class RideRequestArguments {
  final Map<dynamic, dynamic> feedData;
  final String feedId;
  RideRequestArguments({@required this.feedData, @required this.feedId});
}

//JoinTrip arguments holder class
class JoinTripArguments {
  final String tripId;
  final String driverId;
  final Map<dynamic, dynamic> tripData;
  final String paymentToken;
  JoinTripArguments(
      {@required this.tripId,
      @required this.driverId,
      @required this.tripData,
      this.paymentToken});
}
