import 'package:auto_route/auto_route_annotations.dart';
import 'package:passenger/views/Home.dart';
import 'package:passenger/views/onboarding.dart';
import 'package:passenger/views/passengerForm.dart';
import 'package:passenger/views/profilePicture.dart';
import 'package:passenger/views/signup.dart';
import 'package:passenger/views/login.dart';

@autoRouter
class $Routes {
  @initial
  OnboardingSlider onboardingSlider;
  LoginPage loginPage;
  PassengerForm passengerForm;
  Home home;
  SignUP signUp;
  ProfilePicture profilePicture;
}
