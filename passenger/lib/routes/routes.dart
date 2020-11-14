import 'package:auto_route/auto_route_annotations.dart';
import 'package:passenger/views/Home.dart';
import 'package:passenger/views/auth/passengerForm.dart';
import 'package:passenger/views/auth/login.dart';
import 'package:passenger/views/auth/profilePicture.dart';
import 'package:passenger/views/auth/signup.dart';
import 'package:passenger/views/chat/ChatHistory.dart';
import 'package:passenger/views/chat/ChatMessage.dart';
import 'package:passenger/views/chat/previewAttachment.dart';
import 'package:passenger/views/onboarding.dart';

@autoRouter
class $Routes {
  @initial
  OnboardingSlider onboardingSlider;
  LoginPage loginPage;
  PassengerForm passengerForm;
  Home home;
  SignUP signUp;
  ProfilePicture profilePicture;
  ChatHistory chatHistory;
  ChatMessage chatMessage;
  PreviewAttachment previewAttachment;
}
