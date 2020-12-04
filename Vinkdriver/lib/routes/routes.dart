import 'dart:io';

import 'package:Vinkdriver/views/CreateTrip.dart';
import 'package:Vinkdriver/views/DriverFeed.dart';
import 'package:Vinkdriver/views/PokeUserOnTrip.dart';
import 'package:Vinkdriver/views/SearchRide.dart';
import 'package:Vinkdriver/views/VinkDetails.dart';
import 'package:Vinkdriver/views/auth/carRegistration.dart';
import 'package:Vinkdriver/views/auth/forgot_password.dart';
import 'package:Vinkdriver/views/chat/ChatHistory.dart';
import 'package:Vinkdriver/views/chat/ChatMessage.dart';
import 'package:Vinkdriver/views/chat/previewAttachment.dart';
import 'package:Vinkdriver/views/user/Profile.dart';
import 'package:Vinkdriver/views/user/myFeeds.dart';
import 'package:Vinkdriver/widget/negotiatePrice.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:Vinkdriver/views/Home.dart';
import 'package:Vinkdriver/views/onboarding.dart';
import 'package:Vinkdriver/views/auth/driverForm.dart';
import 'package:Vinkdriver/views/auth/profilePicture.dart';
import 'package:Vinkdriver/views/auth/signup.dart';
import 'package:Vinkdriver/views/auth/login.dart';

@autoRouter
class $Routes {
  @initial
  OnboardingSlider onboardingSlider;
  LoginPage loginPage;
  DriverForm driverForm;
  Home home;
  SignUP signUp;
  ProfilePicture profilePicture;
  ChatHistory chatHistory;
  ChatMessage chatMessage;
  PreviewAttachment previewAttachment;
  PokeUserOnTrip pokeUserOnTrip;
  DriverFeed driverFeed;
  VinkDetails vinkDetails;
  NegotiatePrice negotiatePrice;
  SearchRide searchRide;
  CreateTrip createTrip;
  CarRegitration carRegistration;
  MyFeeds myFeeds;
  ForgotPassword forgotPassword;
  Profile profile;
}
