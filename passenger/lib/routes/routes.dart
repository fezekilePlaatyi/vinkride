import 'package:auto_route/auto_route_annotations.dart';
import 'package:passenger/views/passengerForm.dart';
import 'package:passenger/widget/login.dart';

@autoRouter
class $Routes {
  @initial
  LoginPage loginPage;
  PassengerForm passengerForm;
}
