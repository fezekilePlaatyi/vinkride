import 'dart:io';

import 'package:Vinkdriver/views/chat/ChatHistory.dart';
import 'package:Vinkdriver/views/chat/ChatMessage.dart';
import 'package:Vinkdriver/views/chat/previewAttachment.dart';
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
}
