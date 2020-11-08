import 'package:flutter/material.dart';
import 'package:passenger/routes/routes.gr.dart';

void main() => runApp(MyApp());

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
