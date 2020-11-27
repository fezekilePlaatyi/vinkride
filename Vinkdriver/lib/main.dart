import 'package:flutter/material.dart';
import 'package:Vinkdriver/routes/routes.gr.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
 runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.onboardingSlider,
      onGenerateRoute: Routes.onGenerateRoute,
      navigatorKey: Routes.navigatorKey,
    );
  }
}
