import 'package:auto_route/auto_route_annotations.dart';
import 'package:Vinkdriver/views/Home.dart';
import 'package:Vinkdriver/views/onboarding.dart';
import 'package:Vinkdriver/views/driverForm.dart';
import 'package:Vinkdriver/views/profilePicture.dart';
import 'package:Vinkdriver/views/signup.dart';
import 'package:Vinkdriver/views/login.dart';

@autoRouter
class $Routes {
  @initial
  OnboardingSlider onboardingSlider;
  LoginPage loginPage;
  DriverForm driverForm;
  Home home;
  SignUP signUp;
  ProfilePicture profilePicture;
}
