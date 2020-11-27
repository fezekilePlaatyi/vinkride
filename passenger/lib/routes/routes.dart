import 'package:auto_route/auto_route_annotations.dart';
import 'package:passenger/views/CreateTrip.dart';
import 'package:passenger/views/Home.dart';
import 'package:passenger/views/SearchRide.dart';
import 'package:passenger/views/ViewingTrip.dart';
import 'package:passenger/views/VinkDetails.dart';
import 'package:passenger/views/auth/forgot_password.dart';
import 'package:passenger/views/auth/passengerForm.dart';
import 'package:passenger/views/auth/login.dart';
import 'package:passenger/views/auth/profilePicture.dart';
import 'package:passenger/views/auth/signup.dart';
import 'package:passenger/views/chat/ChatHistory.dart';
import 'package:passenger/views/chat/ChatMessage.dart';
import 'package:passenger/views/chat/previewAttachment.dart';
import 'package:passenger/views/onboarding.dart';
import 'package:passenger/views/user/myFeeds.dart';
import 'package:passenger/widgets/JoinTrip.dart';
import 'package:passenger/widgets/RideRequest.dart';

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
  ViewingTrip viewingTrip;
  MyFeeds myFeeds;
  VinkDetails vinkDetails;
  CreateTrip createTrip;
  SearchRide searchRide;
  RideRequest rideRequest;
  JoinTrip joinTrip;
  ForgotPassword forgotPassword;
}
